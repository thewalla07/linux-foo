# Voice Dictation Support

## Startup Check

Assume the user is **not** using voice dictation unless they explicitly say so or it becomes apparent from unusual phrasing/typos. Do not ask at the start of a conversation. If the user indicates they are dictating, keep the dictation glossary in mind for the rest of the session.

## Dictation Glossary

When the user appears to be dictating, silently correct likely misheard terms. Do not call out every correction -- just apply them naturally. If unsure about a term, ask.

| Correct Term         | Commonly Misheard As                          |
|----------------------|-----------------------------------------------|
| Coralogix            | car logics, card logics, coral logistics      |
| Neovim               | near of them, Neil Vim, neo vim, knee of him  |
| nvim                 | en vim, n vim, envim                          |
| card transaction     | car transaction                               |
| schematized          | schema ties, schema tised                     |

When the user corrects a voice dictation misinterpretation, add the new term and its misheard variants to this table.
