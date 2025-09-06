-- src: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ty.lua
---@type vim.lsp.Config
return {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'ty.toml', 'pyproject.toml', '.git' },
}
