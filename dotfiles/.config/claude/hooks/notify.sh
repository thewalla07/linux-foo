#!/usr/bin/env bash
# Notification / Stop hook: build an OS notification that says WHICH session
# wants you and WHAT it wants, instead of a fixed "Claude needs your input".
#
# Wired to both the Notification and Stop events in ~/.claude/settings.json.
#
# Notification payload carries: .message, .title, .notification_type
# Stop payload carries none of those, so the "what" is recovered from the
# transcript instead.
#
# Every run appends to ~/.claude/notify.log, so a notification that never
# appeared can be told apart from a hook that never fired.
#
# Testing:  ~/.claude/bin/test-notify [--live]
# Disable:  touch ~/.claude/notify.off
set -uo pipefail

[ -f "$HOME/.claude/notify.off" ] && exit 0

JQ=/usr/bin/jq
[ -x "$JQ" ] || exit 0

payload=$(cat)
j() { printf '%s' "$payload" | "$JQ" -r "$1 // empty" 2>/dev/null; }

event=$(j '.hook_event_name')
message=$(j '.message')
ntype=$(j '.notification_type')
cwd=$(j '.cwd')
transcript=$(j '.transcript_path')

# Collapse to a single line, drop markdown noise, cap the length. Only strips
# markers that are unambiguously markdown: backticks, ** pairs, and a leading
# bullet/heading/quote marker. Leaves >, *, _ alone mid-string so that shell
# commands and globs survive intact. iconv drops any partial multi-byte
# character left behind by the truncation.
clean() {
  printf '%s' "$1" \
    | /usr/bin/tr '\n' ' ' \
    | /usr/bin/sed -e 's/`//g' -e 's/\*\*//g' \
    | /usr/bin/tr -s '[:space:]' ' ' \
    | /usr/bin/sed -e 's/^[[:space:]]*//' \
                  -e 's/^[#>][[:space:]]*//' \
                  -e 's/^[-•][[:space:]]*//' \
                  -e 's/[[:space:]]*$//' \
    | /usr/bin/cut -c1-180 \
    | /usr/bin/iconv -c -f UTF-8 -t UTF-8 2>/dev/null
}

# --- which session is this? chat title if it has one, else the directory -----
label=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  label=$(/usr/bin/grep -o '"customTitle":"[^"]*"' "$transcript" 2>/dev/null \
          | /usr/bin/tail -n 1 \
          | /usr/bin/sed -e 's/^"customTitle":"//' -e 's/"$//')
fi
[ -n "$label" ] || label=$(/usr/bin/basename "${cwd:-$PWD}")

# --- what is it waiting on? pull the last assistant text + pending tool ------
last_text=""
last_tool=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  recent=$(/usr/bin/tail -n 400 "$transcript" 2>/dev/null)

  # A text block spans many lines, and jq prints those as separate physical
  # lines, so a plain "tail -n 1" would return only the block's final line and
  # the headline search below would never see the rest. Fold newlines onto a
  # sentinel to keep one block on one line, take the last block, then unfold.
  last_text=$(printf '%s\n' "$recent" | "$JQ" -Rr '
      fromjson? | select(.type == "assistant")
      | (.message.content // [])[] | select(.type == "text") | .text
      | gsub("\n"; "@@NL@@")
    ' 2>/dev/null | /usr/bin/tail -n 1 \
    | /usr/bin/awk '{ gsub(/@@NL@@/, "\n"); print }')

  # Same hazard for a multi-line shell command, so collapse its whitespace
  # inside jq to keep each tool_use on one line.
  last_tool=$(printf '%s\n' "$recent" | "$JQ" -Rr '
      fromjson? | select(.type == "assistant")
      | (.message.content // [])[] | select(.type == "tool_use")
      | .name as $name
      | (if (.input.command? | type) == "string" then .input.command
         elif (.input.file_path? | type) == "string" then (.input.file_path | split("/") | last)
         elif (.input.pattern? | type) == "string" then .input.pattern
         elif (.input.description? | type) == "string" then .input.description
         elif (.input.url? | type) == "string" then .input.url
         else "" end) as $raw
      | ($raw | gsub("\\s+"; " ")) as $arg
      | $name + (if $arg == "" then "" else ": " + ($arg | .[0:120]) end)
    ' 2>/dev/null | /usr/bin/tail -n 1)
fi

# Prefer the explicit background-job signals, else the closing line.
headline=""
if [ -n "$last_text" ]; then
  headline=$(printf '%s\n' "$last_text" \
             | /usr/bin/grep -iE '^[[:space:]]*(needs input|result|failed):' \
             | /usr/bin/tail -n 1)
  [ -n "$headline" ] || headline=$(printf '%s\n' "$last_text" \
                                   | /usr/bin/grep -vE '^[[:space:]]*$' \
                                   | /usr/bin/tail -n 1)
fi

# --- reason (subtitle) and detail (body) ------------------------------------
if [ "$event" = "Stop" ]; then
  reason="Turn finished — over to you"
else
  reason="${message:-Needs your attention}"
fi

detail=""
# Agent notifications arrive as "<label> needs your input: <what>" — split so
# the "what" gets its own line instead of being truncated away.
case "$message" in
  *": "*) reason="${message%%: *}"; detail="${message#*: }" ;;
esac

body=""
case "$ntype" in
  *permission*) body="$last_tool" ;;
esac
[ -n "$body" ] || body="$detail"
[ -n "$body" ] || body="$headline"
[ -n "$body" ] || body="$last_tool"
[ -n "$body" ] || body="Open the session to continue."

label=$(clean "$label")
reason=$(clean "$reason")
body=$(clean "$body")

# Leave a trail so a missing notification can be diagnosed: did the hook fire at
# all, and what did it decide to say? Self-trimming.
LOG="$HOME/.claude/notify.log"
printf '%s  [%s/%s]  %s | %s | %s\n' \
  "$(/bin/date '+%Y-%m-%d %H:%M:%S')" "${event:-?}" "${ntype:--}" \
  "$label" "$reason" "$body" >> "$LOG" 2>/dev/null || true
if [ "$(/usr/bin/wc -l < "$LOG" 2>/dev/null || echo 0)" -gt 400 ]; then
  /usr/bin/tail -n 200 "$LOG" > "$LOG.tmp" 2>/dev/null \
    && /bin/mv "$LOG.tmp" "$LOG" 2>/dev/null || true
fi

# NOTIFY_DRY_RUN=1 prints the composed notification instead of showing it.
if [ -n "${NOTIFY_DRY_RUN:-}" ]; then
  printf 'TITLE    %s\nSUBTITLE %s\nBODY     %s\n' "$label" "$reason" "$body"
  exit 0
fi

/usr/bin/osascript - "$body" "$label" "$reason" >/dev/null 2>&1 <<'OSA' || true
on run argv
  display notification (item 1 of argv) with title (item 2 of argv) subtitle (item 3 of argv) sound name "Submarine"
end run
OSA

exit 0
