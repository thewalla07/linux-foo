# nvim config TODO

> Full migration plan: [plans/nvim-config-migration.md](plans/nvim-config-migration.md)

## Phase 4 - UI plugins
- [ ] lualine.nvim - status line
- [ ] bufferline.nvim - tab/buffer bar

## Phase 5 - deferred optional plugins
- [ ] mini.pairs - auto-close brackets/quotes
- [ ] flash.nvim - enhanced motion with jump labels
- [ ] persistence.nvim - auto-save/restore sessions
- [ ] noice.nvim - fancy cmdline/messages/popups UI
- [ ] snacks.nvim - dashboard, indent guides, bigfile handling

## Follow-ups
- [ ] colorscheme: flash of default colorscheme visible during lazy.nvim plugin updates on startup before rose-pine loads
- [ ] which-key: add descriptions to custom keymaps so the popup is more informative
- [ ] gitsigns: add inline diff preview (gitsigns.preview_hunk_inline)
- [ ] lazydev: investigate why it doesn't activate automatically (currently using manual lua_ls globals config as workaround)
- [ ] todo-comments: install a Nerd Font so icons render correctly
- [ ] markdown: add `gd` / `gf` support for following markdown links to local files
