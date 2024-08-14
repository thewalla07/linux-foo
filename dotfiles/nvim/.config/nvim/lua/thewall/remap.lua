vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

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
vim.keymap.set("n", "<leader>f", function()
    -- local filetype = vim.bo.filetype
    -- local formatter =
    -- {
    --     ["typescript"] = "<cmd>silent !prettier --stdin-filepath %<CR>",
    -- }
    -- local formatFunc = formatter[filetype]
    -- if (formatFunc) then
    --     print("Format", filetype, "with own formatter")
    --     return formatFunc
    -- else
    --     print("Format", filetype, "with builtin")
    return vim.lsp.buf.format()
    -- end
end)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/thewall/packer.lua<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

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
