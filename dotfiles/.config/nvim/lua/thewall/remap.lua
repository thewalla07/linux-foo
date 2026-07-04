vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", function()
    if vim.bo.filetype == "netrw" then
        vim.cmd("bwipeout")
    else
        vim.cmd.Ex()
    end
end)

-- fix the # symbol for mac os
vim.keymap.set('i', '<M-3>', '#', { noremap = true, silent = true })
vim.keymap.set('n', '<M-3>', '#', { noremap = true, silent = true })
vim.keymap.set('v', '<M-3>', '#', { noremap = true, silent = true })

-- visual selection and move
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- fast edits
-- toggle To tRue
-- vim.keymap.set("n", "<leader>tr", [[:s/false/true/g<CR>]])
-- toggle To False
-- vim.keymap.set("n", "<leader>tf", [[:s/true/false/g<CR>]])
-- vim.keymap.set("n", "<leader>rmo", [[:%s/\.only(/(/g<CR>]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- <leader>f is defined in lazy.lua conform spec (lazy-loaded)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- removed <leader>x (chmod +x) -- conflicts with trouble.nvim <leader>xx

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/thewall/lazy.lua<CR>");

vim.keymap.set("n", "<leader><leader>", "<cmd>source ~/.config/nvim/init.lua<cr>", { desc = "Reload config" })

-- start neotest
-- vim.keymap.set("n", "<leader>tr", function()
--     require("neotest").run.run()
-- end)
--
-- vim.keymap.set("n", "<leader>tf", function()
--     require("neotest").run.run(vim.fn.expand("%"))
-- end)
--
-- vim.keymap.set("n", "<leader>ts", function()
--     require("neotest").run.stop()
-- end)
--
-- vim.keymap.set("n", "<leader>to", function()
--     require("neotest").run.output_panel()
-- end)
-- end neotest

vim.keymap.set("n", "<leader>zm", function()
    require("zen-mode").toggle({
        window = {
            width = 120 -- using .85 width will be 85% of the editor width
        }
    })
end)

-- neotest remaps
--
--vim.keymap.set("n", "<leader>test", function()
--    require("neotest").run.run(vim.fn.expand("%"))
--end)
--vim.keymap.set("n", "<leader>stop", function()
--    require("neotest").run.stop()
--end)
--
-- end neotest remaps

vim.keymap.set("n", "<leader>nro", function()
    local newValue = not vim.opt.number:get()
    vim.opt.number = newValue
    vim.opt.relativenumber = newValue
end)


local augroup = vim.api.nvim_create_augroup("thewall", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "typescript,typescriptreact",
    group = augroup,
    command = "compiler tsc | setlocal makeprg=npx\\ tsc\\ --build\\ tsconfig.json\\ --pretty\\ false",
})

-- local augroup = vim.api.nvim_create_augroup("thewall", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "typescript,typescriptreact",
--   group = augroup,
--   command = "compiler tsc | setlocal makeprg=npx\\ tsc\\ --build\\ tsconfig.build.json\\ --pretty\\ false",
-- })
--

-- keybinds for 99

-- take extra note that i have visual selection only in v mode
-- technically whatever your last visual selection is, will be used
-- so i have this set to visual mode so i dont screw up and use an
-- old visual selection
--
-- likely ill add a mode check and assert on required visual mode
-- so just prepare for it now
local _99 = require("99")
vim.keymap.set("v", "<leader>9v", function()
    _99.visual()
end)

--- if you have a request you dont want to make any changes, just cancel it
vim.keymap.set("n", "<leader>9x", function()
    _99.stop_all_requests()
end)

vim.keymap.set("n", "<leader>9s", function()
    _99.search()
end)

-- window resizing: hold Alt (Option) + hjkl to resize (normal mode only).
-- because of how keys are reported, this has been change to the actual char
-- which is output from holding Opt+hjkl on macos
-- TODO: find a way to fix this and the remappings to go to older quickfix lists

-- not working currently
vim.keymap.set('n', '<M-k>', ':colder<CR>');
vim.keymap.set('n', '<M-j>', ':cnewer<CR>');

vim.keymap.set("n", "˙", "<C-w><", { desc = "Window narrower" })
vim.keymap.set("n", "∆", "<C-w>+", { desc = "Window taller" })
vim.keymap.set("n", "˚", "<C-w>-", { desc = "Window shorter" })
vim.keymap.set("n", "¬", "<C-w>>", { desc = "Window wider" })

