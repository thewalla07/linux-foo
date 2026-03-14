vim.keymap.set("n", "<leader>gs", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "fugitive" then
      if #vim.api.nvim_list_wins() == 1 then
        local alt = vim.fn.bufnr("#")
        if alt > 0 and vim.api.nvim_buf_is_valid(alt) and alt ~= buf then
          vim.api.nvim_set_current_buf(alt)
        else
          vim.cmd("bprevious")
          if vim.bo.filetype == "fugitive" then
            vim.cmd("enew")
          end
        end
      else
        vim.api.nvim_win_close(win, false)
      end
      return
    end
  end
  vim.cmd.Git()
end, { desc = "Toggle Git status" })
