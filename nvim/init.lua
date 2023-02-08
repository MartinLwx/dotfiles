---------------------
-- global settings---
---------------------
-- Hint: use `:h <option>` to figure out the meaning if needed
vim.opt.tabstop = 4           -- number of visual spaces per TAB
vim.opt.softtabstop = 4       -- number of spacesin tab when editing
vim.opt.shiftwidth = 4        -- insert 4 spaces on a tab
vim.opt.expandtab = true    -- tabs are spaces, mainly because of python
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- UI config
vim.opt.number = true
vim.opt.relativenumber = true       -- add numbers to each line on the left side
vim.opt.cursorline = true           -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true           -- open new vertical split bottom
vim.opt.splitright = true           -- open new horizontal splits right
-- vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI

-- Searching
vim.opt.incsearch = true           -- search as characters are entered
vim.opt.hlsearch = false           -- do not highlight matches
vim.opt.ignorecase = true          -- ignore case in searches by default
vim.opt.smartcase = true           -- but make it case sensitive if an uppercase is entered


-----------------
-- Packer.nvim --
-----------------
return require('packer').startup(function(use)
  -- Packer.nvim hints
  --     after = string or list,           -- Specifies plugins to load before this plugin. See "sequencing" below
  --     config = string or function,      -- Specifies code to run after this plugin is loaded
  --     requires = string or list,        -- Specifies plugin dependencies. See "dependencies". 
  --     ft = string or list,              -- Specifies filetypes which load this plugin.
  --     run = string, function, or table, -- Specify operations to be run after successful installs/updates of a plugin

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- [nvim-cmp] auto-completion engine
  -- Note: 
  --     the default search path for `require` is ~/.config/nvim/lua
  --     use a `.` as a path seperator
  --     the suffix `.lua` is not needed
  use { 'hrsh7th/nvim-cmp', config = [[require('config.nvim-cmp')]] }    
  use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' } 
  use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }        -- buffer auto-completion
  use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }          -- path auto-completion
  use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }       -- cmdline auto-completion

  -- [nvim-lspconfig] (it relies on cmp-nvim-lsp, so it should be loaded after cmp-nvim-lsp).
  use { 'neovim/nvim-lspconfig', after = 'cmp-nvim-lsp' }

  -- [ultisnips] code snippet engine
  use 'SirVer/ultisnips'
  use 'quangnguyen30192/cmp-nvim-ultisnips'

  -- [monokai] my colorscheme choice
  use 'tanvirtin/monokai.nvim'

  -- [vim-fugitive] run git command in Nvim
  use 'tpope/vim-fugitive'

  -- [vim-commentary] code comment helper
  --     1. `gcc` to comment a line
  --     2. select lines in visual mode and run `gc`
  --     3. `gcu` to undo comment
  use 'tpope/vim-commentary'

  -- [vim-markdown] syntax highlightint, matching rules and mappings
  use { 'preservim/vim-markdown', ft = { 'markdown' } }

  -- [LeaderF] fuzzy finder
  use { 'Yggdroot/LeaderF', run = ':LeaderfInstallCExtension' }
end)

