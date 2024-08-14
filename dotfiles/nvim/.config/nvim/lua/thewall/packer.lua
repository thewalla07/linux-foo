-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`]
-- vim.cmd [[packadd packer.nvim]]
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    if packer_bootstrap then
        require('packer').sync()
    end
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        'nmac427/guess-indent.nvim',
        config = function() require('guess-indent').setup {} end,
    }


    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use(
        'nvim-treesitter/nvim-treesitter',
        { run = ':TSUpdate' }
    )
    use 'prettier/vim-prettier'

    use 'nvim-treesitter/playground'
    use {
        'theprimeagen/harpoon',
        branch = 'harpoon2',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope.nvim' }
        }
    }
    use 'mbbill/undotree'
    use 'tpope/vim-fugitive'
    use 'nvim-treesitter/nvim-treesitter-context'
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }

    -- use {
    --     'jose-elias-alvarez/null-ls.nvim',
    --     requires = 'nvim-lua/plenary.nvim'
    -- }

    use {
        'folke/zen-mode.nvim',
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }

    -- use {
    --     "nvim-neotest/neotest",
    --     requires = {
    --         "nvim-neotest/nvim-nio",
    --         "nvim-neotest/neotest-plenary",
    --         "nvim-lua/plenary.nvim",
    --         "antoinemadec/FixCursorHold.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --         'nvim-neotest/neotest-jest',
    --     }
    -- }

    --    use {
    --        'nvim-neotest/neotest',
    --        requires = {
    --            'nvim-lua/plenary.nvim',
    --            'antoinemadec/FixCursorHold.nvim',
    --            'nvim-treesitter/nvim-treesitter',
    --            'thenbe/neotest-playwright',
    --        }
    --    }
end)
