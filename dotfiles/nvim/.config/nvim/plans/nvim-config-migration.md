# Neovim Config Migration Plan

> See also: [TODO.md](../TODO.md) for remaining tasks and follow-ups

## Origin

This plan was created by comparing the local nvim config (ThePrimeagen-style, packer.nvim) against the omarchy distro's LazyVim defaults. The goal is to adopt useful plugins and patterns without depending on LazyVim as a distribution.

## Config Structure

ThePrimeagen-style pattern:
- `init.lua` -> `lua/thewall/init.lua` (loads lazy, remap, set)
- `lua/thewall/lazy.lua` -- plugin declarations (lazy.nvim)
- `lua/thewall/set.lua` -- vim options
- `lua/thewall/remap.lua` -- global keymaps
- `after/plugin/*.lua` -- per-plugin config files

---

## Phase 1 - packer.nvim -> lazy.nvim [DONE]

- [x] Replace packer bootstrap with lazy.nvim bootstrap
- [x] Convert all `use` calls to lazy.nvim spec format
- [x] Set `vim.g.mapleader` before `require("lazy").setup()`
- [x] Delete `plugin/packer_compiled.lua` and packer data directory
- [x] Fix stale treesitter query symlinks pointing to deleted packer path

## Phase 2 - high priority plugins [DONE]

- [x] nvim-treesitter-textobjects -- structural code navigation (`]f`, `[f`, `]c`, `[c`, `af`, `if`, etc.)
- [x] which-key.nvim -- keymap discovery popup
- [x] conform.nvim -- universal formatting (replaced vim-prettier), format_on_save, eslint_d for JS/TS
- [x] gitsigns.nvim -- replaced vim-signify, hunk staging/navigation/blame
- [x] cmp-buffer -- buffer text completions in nvim-cmp

## Phase 3 - medium priority plugins [DONE]

- [x] trouble.nvim -- better diagnostics/quickfix UI (`<leader>xx`, `<leader>xq`)
- [x] mini.ai -- extended text objects (quotes, brackets, tags)
- [x] nvim-lint -- async linting (shellcheck for sh/bash)
- [x] todo-comments.nvim -- highlights TODO/FIXME/HACK comments
- [x] lazydev.nvim -- lua LSP enhancement (needs investigation, using manual lua_ls globals as workaround)
- [x] mason auto-install for formatters/linters (prettier, eslint_d, stylua, shfmt, shellcheck)

## Phase 4 - UI plugins [PENDING]

- [ ] lualine.nvim -- status line
- [ ] bufferline.nvim -- tab/buffer bar

## Phase 5 - deferred optional plugins [PENDING]

- [ ] mini.pairs -- auto-close brackets/quotes
- [ ] flash.nvim -- enhanced motion with jump labels
- [ ] persistence.nvim -- auto-save/restore sessions
- [ ] noice.nvim -- fancy cmdline/messages/popups UI
- [ ] snacks.nvim -- dashboard, indent guides, bigfile handling

---

## Plugins kept as-is (equal or better than LazyVim)

- telescope.nvim (custom grep args well-tuned for workflow)
- lsp-zero + mason + nvim-lspconfig + nvim-cmp (full LSP stack)
- harpoon v2 (file navigation)
- undotree (undo history)
- vim-fugitive (git)
- zen-mode.nvim (distraction-free editing)
- 99 (AI-assisted coding)
- adopure.nvim (Azure DevOps PR review)
- omnisharp-extended-lsp.nvim (C# enhanced go-to-definition)
- guess-indent.nvim (auto-detect indentation)
- rose-pine (colorscheme)

---

## Plugin-by-Plugin Comparison Reference

### Equivalent Plugins

| Category | Your Plugin | LazyVim Plugin | Verdict |
|----------|------------|----------------|---------|
| Fuzzy finding | telescope.nvim | snacks.nvim picker | Keep yours -- more tailored grep config |
| LSP | lsp-zero v3 + mason | nvim-lspconfig + mason directly | lsp-zero fine to keep, same underlying plugins |
| Completion | nvim-cmp + cmp-nvim-lsp | nvim-cmp or blink.cmp | Added cmp-buffer |
| Treesitter | nvim-treesitter + context | + textobjects + ts-autotag | Added textobjects |
| Git signs | ~~vim-signify~~ -> gitsigns | gitsigns | Migrated |
| Git commands | vim-fugitive | lazygit TUI | Fugitive is more powerful, keep it |
| Colorscheme | rose-pine | tokyonight/catppuccin | Personal preference |
| Indentation | guess-indent.nvim | treesitter + editorconfig | Keep guess-indent |

### Plugins Added from LazyVim

| Plugin | Phase | Status |
|--------|-------|--------|
| lazy.nvim (plugin manager) | 1 | done |
| treesitter-textobjects | 2 | done |
| which-key.nvim | 2 | done |
| conform.nvim | 2 | done |
| gitsigns.nvim | 2 | done |
| cmp-buffer | 2 | done |
| trouble.nvim | 3 | done |
| mini.ai | 3 | done |
| nvim-lint | 3 | done |
| todo-comments.nvim | 3 | done |
| lazydev.nvim | 3 | done (partial) |
| lualine.nvim | 4 | pending |
| bufferline.nvim | 4 | pending |
| mini.pairs | 4 | pending |
| flash.nvim | 4 | pending |
| persistence.nvim | 4 | pending |
| noice.nvim | 4 | pending |
| snacks.nvim | 4 | pending |
