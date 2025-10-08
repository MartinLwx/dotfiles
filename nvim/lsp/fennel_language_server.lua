---@brief
---
--- https://github.com/rydesun/fennel-language-server
---
--- Fennel language server protocol (LSP) support.
---
--- src: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/fennel_language_server.lua

---@type vim.lsp.Config
return {
	cmd = { "fennel-language-server" },
	filetypes = { "fennel" },
	root_markers = { ".git" },
	settings = {},
}
