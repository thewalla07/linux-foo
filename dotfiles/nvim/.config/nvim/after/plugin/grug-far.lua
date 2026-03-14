local grug = require("grug-far")

grug.setup({
  headerMaxWidth = 80,
  windowCreationCommand = "split",
})

vim.keymap.set("n", "<leader>sr", function()
  grug.open()
end, { desc = "Search and replace" })

vim.keymap.set("n", "<leader>sw", function()
  grug.open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search current word" })

vim.keymap.set("n", "<leader>sf", function()
  grug.open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Search in current file" })

vim.keymap.set("v", "<leader>sr", function()
  grug.with_visual_selection()
end, { desc = "Search selection" })
