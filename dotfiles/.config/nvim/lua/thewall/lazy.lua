vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to continue..." },
		}, true, {})
		vim.fn.getchar()
		return
	end
end
vim.opt.rtp:prepend(lazypath)

-- Insert an "AUTHOR:" comment on a new line below (or above) the cursor line and
-- drop into insert mode. Uses the buffer's commentstring so it works per-filetype.
-- AUTHOR: is my voice; Claude replies in-thread with CLAUDE: comments beneath.
local function author_comment(above)
	local cs = vim.bo.commentstring
	if cs == "" or not cs:find("%s", 1, true) then
		cs = "// %s"
	end
	local prefix, suffix = cs:match("^(.*)%%s(.*)$")
	prefix = vim.trim(prefix) .. " "
	suffix = vim.trim(suffix) ~= "" and (" " .. vim.trim(suffix)) or ""

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local cur = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
	local body = cur:match("^%s*") .. prefix .. "AUTHOR: "
	local at = above and row - 1 or row

	vim.api.nvim_buf_set_lines(0, at, at, false, { body .. suffix })
	if suffix == "" then
		vim.api.nvim_win_set_cursor(0, { at + 1, 0 })
		vim.cmd("startinsert!") -- like `A`: append at end of line
	else
		vim.api.nvim_win_set_cursor(0, { at + 1, #body })
		vim.cmd("startinsert") -- park the cursor before the closing delimiter
	end
end

require("lazy").setup({
	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},

	-- C# enhanced go-to-definition
	{ "Hoffs/omnisharp-extended-lsp.nvim" },

	-- Auto-detect indentation
	{
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},

	-- Colorscheme
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
	},

	-- Buffer/tab bar
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format()
				end,
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				sh = { "shfmt" },
			},
			default_format_opts = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
		},
	},

	-- File navigation
	{
		"theprimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	-- Undo history
	{ "mbbill/undotree" },

	-- Git
	{ "tpope/vim-fugitive" },
	{ "lewis6991/gitsigns.nvim" },

	-- Project-wide search and replace
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		keys = {
			{ "<leader>sr", desc = "Search and replace" },
			{ "<leader>sw", desc = "Search current word" },
			{ "<leader>sf", desc = "Search in current file" },
			{ "<leader>sr", mode = "v", desc = "Search selection" },
		},
	},

	-- LSP + completion
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			{ "mason-org/mason.nvim" },
			{ "mason-org/mason-lspconfig.nvim" },
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "L3MON4D3/LuaSnip" },
		},
	},
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"prettier",
				"eslint_d",
				"stylua",
				"shfmt",
				"shellcheck",
				"csharpier",
				"netcoredbg",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed or {}) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},

	-- Azure DevOps PR review
	{
		"Willem-J-an/adopure.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			vim.g.adopure = {}
		end,
	},

	-- Diagnostics UI
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (project)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
		},
		opts = {
			modes = {
				-- Distinct mode name so it gets its own view; reusing "todo" with a
				-- different filter arg just re-focuses the existing unfiltered list.
				todo_claude = {
					mode = "todo",
					filter = { tag = "CLAUDE" },
				},
				todo_author = {
					mode = "todo",
					filter = { tag = "AUTHOR" },
				},
			},
		},
	},

	-- Extended text objects (quotes, brackets, tags, etc.)
	{
		"echasnovski/mini.ai",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},

	-- Async linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- TODO/FIXME/HACK comment highlighting
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			keywords = {
				-- Claude's replies, threaded below an AUTHOR: comment.
				CLAUDE = { icon = "󰚩 ", color = "claude" },
				-- My voice: questions/requests for Claude, e.g. "// AUTHOR: why is this nil here?"
				AUTHOR = { icon = "󰠗 ", color = "author" },
			},
			colors = {
				claude = { "#D97757" }, -- Claude brand orange
				author = { "#C4A7E7" }, -- pastel purple (rose-pine iris)
			},
		},
		keys = {
			{ "<leader>ta", "<cmd>TodoTelescope keywords=AUTHOR<cr>", desc = "Find AUTHOR comments" },
			{ "<leader>tc", "<cmd>TodoTelescope keywords=CLAUDE<cr>", desc = "Find CLAUDE comments" },
			{ "<leader>tm", "<cmd>TodoTelescope<cr>", desc = "Find all todo comments" },
			{ "<leader>tt", function() author_comment(false) end, desc = "AUTHOR comment (line below)" },
			{ "<leader>tT", function() author_comment(true) end, desc = "AUTHOR comment (line above)" },
		},
	},

	-- Lua LSP enhancement for Neovim config editing (must load before lua_ls)
	-- TODO: fix this later, this is currently not giving global completions
	{
		"folke/lazydev.nvim",
		ft = "lua",
		lazy = true,
	},

	-- Keymap discovery
	{ "folke/which-key.nvim", event = "VeryLazy" },

	-- Distraction-free editing
	{ "folke/zen-mode.nvim", opts = {} },

	-- AI-assisted coding
	{ "ThePrimeagen/99" },

	-- Flutter tools
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- "stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = true,
	},
})
