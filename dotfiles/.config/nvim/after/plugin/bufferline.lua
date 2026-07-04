require("bufferline").setup({
  options = {
    mode = "buffers",
    diagnostics = "nvim_lsp",
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "thin",
    offsets = {
      { filetype = "undotree", text = "Undo Tree", text_align = "center" },
      { filetype = "fugitive", text = "Git", text_align = "center" },
    },
    custom_filter = function(buf_number)
      local dominated_fts = { netrw = true, fugitive = true, git = true }
      if dominated_fts[vim.bo[buf_number].filetype] then
        return false
      end
      return true
    end,
  },
})

vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })
vim.keymap.set("n", "<leader>bx", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
