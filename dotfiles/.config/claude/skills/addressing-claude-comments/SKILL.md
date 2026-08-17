---
name: addressing-claude-comments
description: Use when the user asks to address, action, answer, handle, or clear `AUTHOR:` comments left in code, or refers to "AUTHOR comments", "CLAUDE comments", inline comment threads, or notes they left inline in the code for Claude to pick up later.
---

# Addressing AUTHOR Comments

## Overview

The user and Claude hold threaded conversations in code comments. Two keywords, two voices:

| Keyword | Voice | Meaning |
|---|---|---|
| `AUTHOR:` | **The user** | A question or request for Claude, anchored to a line |
| `CLAUDE:` | **You** | Your reply, threaded directly beneath |

These two keywords are the whole vocabulary. Never introduce variants such as `AI:` or the user's name — they are not recognized.

A thread is a run of adjacent comment lines alternating between the two. The user appends a new `AUTHOR:` line below your reply to continue it.

## Finding them

Sweep the **whole repo**, never just changed or open files:

```bash
rg -n --no-heading '\b(AUTHOR|CLAUDE):' .
```

Comment syntax varies by language (`//`, `--`, `#`, `<!-- -->`), so match on the keyword, never the delimiter.

## Which threads need you

**Only act on a thread whose LAST comment is `AUTHOR:`.** That is the unanswered signal.

If the last line is `CLAUDE:`, the thread is waiting on the user — leave it completely alone. Re-answering settled threads is the main failure mode here.

## Replying

Append your reply as a comment line directly below the last line of the thread, matching the surrounding indentation and the file's comment syntax. For a multi-line reply, continue on further comment lines **without** repeating the `CLAUDE:` keyword, so each reply counts once in the user's todo list.

```js
  // AUTHOR: why is this nil here?
  // CLAUDE: `user` is unset until the session middleware runs, and this handler
  //   is mounted before it — see server.ts:42.
  // AUTHOR: then move the mount below it
  // CLAUDE: done, now mounted at server.ts:57.
  const name = user?.name ?? "";
```

## Workflow

1. Sweep the repo. List every thread with its `file:line`, and note which are unanswered.
2. Read enough surrounding code to understand each one.
3. Handle each unanswered thread by shape:

| Shape | Example | Action |
|---|---|---|
| Question | `// AUTHOR: why is this nil here?` | Reply with a `CLAUDE:` comment. **Do not change the code.** |
| Instruction | `// AUTHOR: make this handle null` | Make the change, then resolve the thread (below). |
| Ambiguous | `// AUTHOR: this looks wrong` | Reply asking what they want, rather than guessing. |

4. After carrying out an instruction, resolve the thread:

| Outcome | What to do |
|---|---|
| Change was trivial and self-evident | Delete the whole thread — every line of it. |
| Change warrants the user's review | Keep the thread and append a `CLAUDE:` reply saying **what to focus the review on and why**. |

<Bad>
// CLAUDE: updated this function
</Bad>

<Good>
// CLAUDE: assumed a missing user should yield "" rather than throw — confirm that matches the caller in checkout.ts
</Good>

5. Summarize in chat as well as inline: per thread, `file:line`, what was asked, what you did, and whether you deleted or replied.

## Leaving CLAUDE comments proactively

`CLAUDE:` is not only for replies. During ordinary coding work, leave a standalone `// CLAUDE:` comment on code that warrants the user's attention later — an assumption you had to make, a tradeoff, a branch you could not verify, a spot where the right answer needed context you lacked.

Keep them rare enough to stay signal. A file dotted with them is noise; two well-placed ones get read.

## Common mistakes

- **Replying to a thread that already ends in `CLAUDE:`.** It is waiting on the user, not on you.
- **Editing code in response to a question.** A question wants a reply, not a patch.
- Deleting an `AUTHOR:` comment without addressing it.
- Sweeping only changed files — the user expects the whole repo every time.
- Repeating the `CLAUDE:` keyword on every continuation line, which inflates the todo list.
- Replies that narrate the change instead of directing the review.
- Keeping a thread alive as a hedge when the change was obvious. Delete it.
