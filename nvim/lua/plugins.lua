-----------------
-- Packer.nvim --
-----------------
-- Install Packer automatically if it's not installed(Bootstraping)
-- Hint: string concatenation is done by `..`
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


-- Reload configurations if we modify plugins.lua
-- Hint
--     <afile> - replaced with the filename of the buffer being manipulated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])


-- Install plugins here - `use ...`
-- Packer.nvim hints
--     after = string or list,           -- Specifies plugins to load before this plugin. See "sequencing" below
--     config = string or function,      -- Specifies code to run after this plugin is loaded
--     requires = string or list,        -- Specifies plugin dependencies. See "dependencies".
--     ft = string or list,              -- Specifies filetypes which load this plugin.
--     run = string, function, or table, -- Specify operations to be run after successful installs/updates of a plugin
return require('packer').startup(function(use)
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        -- LSP manager
        use { 'williamboman/mason.nvim' }
        use { 'williamboman/mason-lspconfig.nvim' }
        use { 'neovim/nvim-lspconfig' }

        -- Add hooks to LSP to support Linter && Formatter
        use { 'nvim-lua/plenary.nvim' }
        use {
            'jay-babu/mason-null-ls.nvim',
            after = 'plenary.nvim',
            requires = { 'jose-elias-alvarez/null-ls.nvim' },
            config=[[require('config.mason-null-ls')]]
        }

        -- Vscode-like pictograms
        use { 'onsails/lspkind.nvim', event = 'VimEnter' }

        -- Auto-completion engine
        -- Note:
        --     the default search path for `require` is ~/.config/nvim/lua
        --     use a `.` as a path seperator
        --     the suffix `.lua` is not needed
        use { 'hrsh7th/nvim-cmp', after = 'lspkind.nvim', config = [[require('config.nvim-cmp')]] }
        use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
        use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' } -- buffer auto-completion
        use { 'hrsh7th/cmp-path', after = 'nvim-cmp' } -- path auto-completion
        use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' } -- cmdline auto-completion


        -- Code snippet engine
        use 'L3MON4D3/LuaSnip'
        use { 'saadparwaiz1/cmp_luasnip', after = { 'nvim-cmp', 'LuaSnip' } }

        -- Colorscheme
        use 'tanvirtin/monokai.nvim'

        -- Git integration
        use 'tpope/vim-fugitive'

        -- Git decorations
        use { 'lewis6991/gitsigns.nvim', config = [[require('config.gitsigns')]] }

        -- Autopairs: [], (), "", '', etc
        -- it relies on nvim-cmp
        use {
            "windwp/nvim-autopairs",
            after = 'nvim-cmp',
            config = [[require('config.nvim-autopairs')]],
        }

        -- Code comment helper
        --     1. `gcc` to comment a line
        --     2. select lines in visual mode and run `gc` to comment/uncomment lines
        use 'tpope/vim-commentary'

        -- Treesitter-integration
        use {
            'nvim-treesitter/nvim-treesitter',
            run = function()
                local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                ts_update()
            end,
            config = [[require('config.nvim-treesitter')]],
        }

        -- Show indentation and blankline
        use { 'lukas-reineke/indent-blankline.nvim', config = [[require('config.indent-blankline')]] }

        -- Status line
        use {
            'nvim-lualine/lualine.nvim',
            requires = { 'kyazdani42/nvim-web-devicons', opt = true },
            config = [[require('config.lualine')]],
        }

        -- Markdown support
        use { 'preservim/vim-markdown', ft = { 'markdown' } }

        -- Markdown previewer
        -- It require nodejs and yarn. Use homebrew to install first
        use {
            "iamcco/markdown-preview.nvim",
            run = "cd app && npm install",
            setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
            ft = { "markdown" },
        }

        -- Smart indentation for Python
        use { "Vimjas/vim-python-pep8-indent", ft = { "python" } }

        -- File explorer
        use {
            'nvim-tree/nvim-tree.lua',
            requires = {
                'nvim-tree/nvim-web-devicons', -- optional, for file icons
            },
            config = [[require('config.nvim-tree')]]
        }

        -- Smart motion
        use {
            'phaazon/hop.nvim',
            branch = 'v2', -- optional but strongly recommended
            config = function()
                -- you can configure Hop the way you like here; see :h hop-config
                require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
            end
        }

        -- Better terminal integration
        -- tag = string,                -- Specifies a git tag to use. Supports '*' for "latest tag"
        use { "akinsho/toggleterm.nvim", tag = '*', config = [[require('config.toggleterm')]] }

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if packer_bootstrap then
            require('packer').sync()
        end
    end)
