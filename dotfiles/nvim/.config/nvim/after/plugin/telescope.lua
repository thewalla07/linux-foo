local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', function ()
    builtin.find_files({ hidden = true })
end)
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > " ), vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '-u', '--hidden', '--glob=!node_modules', '--glob=!dist', '--glob=!coverage' } });
end)

vim.keymap.set('n', '<M-k>', ':colder<CR>');
vim.keymap.set('n', '<M-j>', ':cnewer<CR>');
