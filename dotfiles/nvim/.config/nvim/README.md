# neovim config

lazy.nvim-based neovim config with a ThePrimeagen-style structure (harpoon, telescope, LSP, etc.).

## structure

```
nvim/
├── init.lua              # entry point, requires thewall
├── lua/thewall/
│   ├── init.lua          # loads lazy, remap, set
│   ├── lazy.lua          # plugin definitions (lazy.nvim)
│   ├── remap.lua         # global keymaps
│   └── set.lua           # vim options
└── after/plugin/         # plugin-specific config (telescope, harpoon, lsp, etc.)
```

## plugins

| plugin                 | purpose                                  |
| ---------------------- | ---------------------------------------- |
| telescope              | fuzzy finder (files, grep, git files)    |
| harpoon                | quick file navigation (pin & jump)       |
| lsp-zero + mason       | LSP, completion, auto-install tools      |
| gitsigns               | git hunks, stage/reset, blame, diff      |
| vim-fugitive           | git commands                             |
| trouble.nvim           | diagnostics, quickfix, loclist UI        |
| bufferline             | buffer/tab bar                           |
| conform.nvim           | format on save + manual format           |
| undotree               | persistent undo history                  |
| zen-mode               | distraction-free editing                 |
| 99                     | AI-assisted coding                       |
| nvim-treesitter        | syntax, folds, textobjects               |
| mini.ai                | extended text objects (quotes, brackets) |
| rose-pine              | colorscheme                              |
| lualine                | status line                              |
| which-key              | keymap discovery                         |
| adopure                | Azure DevOps PR review                   |
| omnisharp-extended-lsp | C# enhanced go-to-definition             |
| guess-indent           | auto-detect indentation                  |
| nvim-lint              | async linting                            |
| todo-comments          | TODO/FIXME/HACK highlighting             |

## key shortcuts

leader key: `<space>`

### navigation

| key                                   | action                          |
| ------------------------------------- | ------------------------------- |
| `<leader>pv`                          | file explorer (Ex)              |
| `<C-p>`                               | telescope: git files            |
| `<leader>pf`                          | telescope: find files (hidden)  |
| `<leader>ps`                          | telescope: grep string          |
| `<leader>pb`                          | telescope: grep (custom prompt) |
| `<leader>a`                           | harpoon: add file               |
| `<C-e>`                               | harpoon: toggle quick menu      |
| `<C-h>` / `<C-t>` / `<C-n>` / `<C-s>` | harpoon: jump to 1/2/3/4        |
| `<C-S-P>` / `<C-S-N>`                 | harpoon: prev/next in list      |
| `<C-f>`                               | tmux sessionizer                |

### buffers

| key          | action              |
| ------------ | ------------------- |
| `<S-h>`      | prev buffer         |
| `<S-l>`      | next buffer         |
| `<leader>bp` | pin buffer          |
| `<leader>bx` | close other buffers |

### LSP

| key              | action                                        |
| ---------------- | --------------------------------------------- |
| `gd`             | go to definition (omnisharp telescope for C#) |
| `gD`             | declaration                                   |
| `gi`             | implementation                                |
| `K`              | hover                                         |
| `<leader>r`      | references (deduped)                          |
| `<leader>vrn`    | rename                                        |
| `<leader>vws`    | workspace symbol                              |
| `<leader>vca`    | code action                                   |
| `<leader>vd`     | diagnostic float                              |
| `]d` / `]]`      | next diagnostic                               |
| `[d` / `[[`      | prev diagnostic                               |
| `<C-h>` (insert) | signature help                                |

### diagnostics (trouble)

| key          | action                |
| ------------ | --------------------- |
| `<leader>xx` | diagnostics (project) |
| `<leader>xX` | diagnostics (buffer)  |
| `<leader>xq` | quickfix list         |
| `<leader>xl` | location list         |

### git (gitsigns)

| key                         | action          |
| --------------------------- | --------------- |
| `]h` / `[h`                 | next/prev hunk  |
| `<leader>hs`                | stage hunk      |
| `<leader>hr`                | reset hunk      |
| `<leader>hS`                | stage buffer    |
| `<leader>hu`                | undo stage hunk |
| `<leader>hR`                | reset buffer    |
| `<leader>hp`                | preview hunk    |
| `<leader>hb`                | blame line      |
| `<leader>hd` / `<leader>hD` | diff this       |
| `ih` (operator)             | select hunk     |

### git (fugitive)

| key          | action     |
| ------------ | ---------- |
| `<leader>gs` | Git status |

### formatting

| key         | action                  |
| ----------- | ----------------------- |
| `<leader>f` | format buffer (conform) |

### undotree

| key         | action          |
| ----------- | --------------- |
| `<leader>u` | toggle undotree |

### zen-mode

| key          | action                     |
| ------------ | -------------------------- |
| `<leader>zm` | toggle zen mode (120 cols) |

### 99 AI

| key          | action                    |
| ------------ | ------------------------- |
| `<leader>9v` | 99 visual (use selection) |
| `<leader>9s` | 99 search                 |
| `<leader>9x` | 99 stop all requests      |

### text objects (treesitter)

| key         | action                |
| ----------- | --------------------- |
| `af` / `if` | function outer/inner  |
| `ac` / `ic` | class outer/inner     |
| `aa` / `ia` | parameter outer/inner |
| `]f` / `[f` | next/prev function    |
| `]c` / `[c` | next/prev class       |
| `]a` / `[a` | next/prev parameter   |

### general remaps

| key                       | action                             |
| ------------------------- | ---------------------------------- |
| `J`                       | join lines (cursor preserved)      |
| `<C-d>` / `<C-u>`         | half-page scroll (centered)        |
| `n` / `N`                 | search next/prev (centered)        |
| `v` + `J` / `K`           | move selection down/up             |
| `<leader>p` (visual)      | paste without overwriting register |
| `<leader>y` / `<leader>Y` | yank to clipboard                  |
| `<leader>d`               | delete to void register            |
| `<C-c>` (insert)          | escape                             |
| `<leader>s`               | replace word under cursor          |
| `<C-j>` / `<C-k>`         | cnext/cprev                        |
| `<leader>j` / `<leader>k` | lprev/lnext                        |
| `<leader>nro`             | toggle line numbers                |
| `<leader><leader>`        | source current file                |
| `<leader>vpp`             | edit plugin config                 |
| `˙` / `∆` / `˚` / `¬`     | window resize (opt+hjkl on mac)    |

## mason auto-installed tools

- prettier
- eslint_d
- stylua
- shfmt
- shellcheck
- csharpier
- netcoredbg

LSP servers (mason-lspconfig): ts_ls, rust_analyzer, eslint, gopls, lua_ls, ansiblels, omnisharp
