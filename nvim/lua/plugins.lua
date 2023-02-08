-----------------
-- Packer.nvim --
-----------------
-- Install Packer automatically if it's not installed(Bootstraping)
-- Hint: string concatenation is done by `..`
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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

  -- [nvim-lspconfig] 
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim'}
  use { 'neovim/nvim-lspconfig' }

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


  -- [LuaSnip] code snippet engine
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

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

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

