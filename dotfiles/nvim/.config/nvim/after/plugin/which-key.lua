local wk = require("which-key")

wk.setup({
  delay = 300,
})

wk.add({
  { "<leader>p", group = "project/find" },
  { "<leader>v", group = "vim/lsp" },
  { "<leader>h", group = "git hunks" },
  { "<leader>x", group = "diagnostics" },
  { "<leader>9", group = "99 AI" },
  { "<leader>g", group = "git" },
  { "<leader>a", group = "adopure/harpoon" },
})
