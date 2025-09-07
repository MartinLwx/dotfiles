-- src: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/clojure_lsp.lua
---@type vim.lsp.Config
return {
	cmd = { "clojure-lsp" },
	filetypes = { "clojure", "edn" },
    root_markers = { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', '.git', 'bb.edn' },
}
