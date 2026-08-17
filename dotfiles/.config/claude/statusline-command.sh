#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
user=$(whoami)
host=$(hostname -s)
branch=$(git -C "$cwd" --no-optional-locks branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p')

model=$(echo "$input" | jq -r '.model.display_name // empty')
model_id=$(echo "$input" | jq -r '.model.id // empty')
# Absent when the current model doesn't support the effort parameter.
effort=$(echo "$input" | jq -r '.effort.level // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

if [ -n "$cost_usd" ]; then
  # PRIMARY: use the harness-provided actual session cost.
  cost=$(awk "BEGIN { printf \"%.4f\", $cost_usd }")
else
  # FALLBACK: estimate from token counts using a per-model pricing table
  # (USD per 1M tokens: input / output). Match on model.id first, falling
  # back to display_name. Order matters: more specific patterns first.
  #   fable / mythos                         -> $10 / $50
  #   opus 5, 4.8, 4.7, 4.6                  -> $5  / $25
  #   any other opus (4.5 and earlier, 3)    -> $15 / $75
  #   sonnet (any)                           -> $3  / $15
  #   haiku 4.5                              -> $1  / $5
  #   haiku 3.5                              -> $0.80 / $4
  #   haiku 3                                -> $0.25 / $1.25
  #   unrecognized                           -> $5 / $25 (show ?)
  model_ref="${model_id:-$model}"
  model_ref_lc=$(printf '%s' "$model_ref" | tr 'A-Z' 'a-z')
  cost_unknown=""
  case "$model_ref_lc" in
    *fable*|*mythos*)
      price_in=10; price_out=50 ;;
    *opus*5*|*opus*4*8*|*opus*4.8*|*opus*4*7*|*opus*4.7*|*opus*4*6*|*opus*4.6*)
      price_in=5; price_out=25 ;;
    *opus*)
      price_in=15; price_out=75 ;;
    *sonnet*)
      price_in=3; price_out=15 ;;
    *haiku*4.5*)
      price_in=1; price_out=5 ;;
    *haiku*3.5*)
      price_in=0.80; price_out=4 ;;
    *haiku*3*)
      price_in=0.25; price_out=1.25 ;;
    *)
      price_in=5; price_out=25; cost_unknown="?" ;;
  esac

  cost=$(awk "BEGIN { printf \"%.4f\", ($total_in / 1000000 * $price_in) + ($total_out / 1000000 * $price_out) }")
  cost="${cost}${cost_unknown}"
fi

total_tokens=$((total_in + total_out))

# Compact token counts: 1234 -> 1.2k, 1234567 -> 1.2M
fmt_tokens() {
  awk "BEGIN {
    n = $1
    if (n >= 1000000) { v = n / 1000000; printf (v == int(v) ? \"%dM\" : \"%.1fM\"), v }
    else if (n >= 1000) { v = n / 1000; printf (v == int(v) ? \"%dk\" : \"%.1fk\"), v }
    else printf \"%d\", n
  }"
}

# Seconds until a unix epoch -> compact "2d3h" / "3h12m" / "45m" / "now"
fmt_eta() {
  awk "BEGIN {
    s = $1 - $2
    if (s <= 0) { printf \"now\"; exit }
    d = int(s / 86400); s -= d * 86400
    h = int(s / 3600);  s -= h * 3600
    m = int(s / 60)
    if (d > 0) printf \"%dd%dh\", d, h
    else if (h > 0) printf \"%dh%dm\", h, m
    else printf \"%dm\", m
  }"
}

# 256-colour code by utilisation: green < 50, yellow < 75, orange < 90, red >= 90
pct_color() {
  awk "BEGIN {
    p = $1
    if (p >= 90) printf \"196\"
    else if (p >= 75) printf \"208\"
    else if (p >= 50) printf \"220\"
    else printf \"82\"
  }"
}

token_str=$(fmt_tokens "$total_tokens")

# ---------------------------------------------------------------- line 1 -----
printf '\033[38;5;243m%s@%s \033[38;5;197m%s \033[38;5;39m%s\033[0m' "$user" "$host" "$cwd" "$branch"

# Disable model/cost and the whole usage line by creating ~/.claude/statusline-minimal
# (touch ~/.claude/statusline-minimal  -> disable; rm to re-enable)
minimal=""
[ -f "$HOME/.claude/statusline-minimal" ] && minimal=1

if [ -n "$model" ] && [ -z "$minimal" ]; then
  printf ' \033[38;5;243m│ \033[38;5;214m%s\033[0m' "$model"
  [ -n "$effort" ] && printf ' \033[38;5;141m(%s)\033[0m' "$effort"
  printf ' \033[38;5;243m│ cost: \033[38;5;82m$%s\033[0m' "$cost"
fi

# ---------------------------------------------------------------- line 2 -----
# Context-window usage plus subscription rate limits: the 5-hour session window,
# the 7-day weekly window, and any per-model weekly windows the harness exposes.
# rate_limits is only present for Claude.ai subscribers after the first API
# response, so every block here is rendered only when its data is available.
[ -n "$minimal" ] && exit 0

now=$(date +%s)
line2=""

if [ -n "$ctx_pct" ] && [ "$ctx_size" -gt 0 ] 2>/dev/null; then
  ctx_col=$(pct_color "$ctx_pct")
  ctx_size_str=$(fmt_tokens "$ctx_size")
  line2=$(printf '\033[38;5;243mctx \033[38;5;%sm%s%%\033[0m \033[38;5;243m(%s/%s)\033[0m' \
    "$ctx_col" "$ctx_pct" "$token_str" "$ctx_size_str")
fi

# key<TAB>used_percentage<TAB>resets_at, one row per populated window
limits=$(echo "$input" | jq -r '
  .rate_limits // {} | to_entries
  | map(select(.value.used_percentage != null))
  | .[] | "\(.key)\t\(.value.used_percentage)\t\(.value.resets_at // 0)"
' 2>/dev/null)

if [ -n "$limits" ]; then
  # Stable, useful ordering: session window, then weekly, then per-model weekly.
  for key in five_hour seven_day seven_day_opus seven_day_sonnet seven_day_oauth_apps; do
    row=$(printf '%s\n' "$limits" | awk -F'\t' -v k="$key" '$1 == k { print; exit }')
    [ -z "$row" ] && continue
    pct=$(printf '%s' "$row" | cut -f2)
    reset=$(printf '%s' "$row" | cut -f3)
    case "$key" in
      five_hour)            label="5h"        ;;
      seven_day)            label="7d"        ;;
      seven_day_opus)       label="7d opus"   ;;
      seven_day_sonnet)     label="7d sonnet" ;;
      seven_day_oauth_apps) label="7d apps"   ;;
    esac
    col=$(pct_color "$pct")
    eta=""
    if [ "$reset" -gt 0 ] 2>/dev/null; then
      eta=$(printf ' \033[38;5;243m\xe2\x86\xba%s' "$(fmt_eta "$reset" "$now")")
    fi
    block=$(printf '\033[38;5;243m%s \033[38;5;%sm%s%%\033[0m%s\033[0m' "$label" "$col" "$pct" "$eta")
    if [ -n "$line2" ]; then
      line2=$(printf '%s \033[38;5;238m│\033[0m %s' "$line2" "$block")
    else
      line2="$block"
    fi
  done
fi

[ -n "$line2" ] && printf '\n%s' "$line2"

exit 0
