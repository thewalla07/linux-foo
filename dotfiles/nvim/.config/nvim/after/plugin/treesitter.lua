
require 'nvim-treesitter'.install {
  -- typescript
  "tsx",
  "typescript",
  "javascript",

  -- vim / lua
  "lua",
  "luap",
  "vim",
  "vimdoc",

  -- treesitter query
  "query",

  -- configs
  "json",
  "yaml",

  -- documents
  "latex",
  "markdown",
  "markdown_inline",

  -- git
  "diff",
  "gitignore",
  "gitcommit",
  "gitattributes",
  "git_config",
  "git_rebase",

  -- shell
  "bash",
  "zsh",

  -- go
  "go",

  -- other langs
  "rust",
  "c",
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',  -- or list specific filetypes
  callback = function()
    -- Enable treesitter highlighting (provided by Neovim)
    pcall(vim.treesitter.start)

    -- Optional: Enable treesitter-based folding (provided by Neovim)
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'

    -- Optional: Enable treesitter-based indentation (provided by nvim-treesitter, experimental)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { '*' },
--   callback = function()
--     if pcall(vim.treesitter.start) then
--       return
--     end
--   end,
-- })
