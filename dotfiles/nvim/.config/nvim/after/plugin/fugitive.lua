vim.keymap.set("n", "<leader>gs", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "fugitive" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd.Git()
end, { desc = "Toggle Git status" })
