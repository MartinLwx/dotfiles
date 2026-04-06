vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-tree/nvim-web-devicons", -- if you prefer nvim-web-devicons
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})
require("render-markdown").setup({
	-- Completions for checkbox and callouts.
	completions = { lsp = { enabled = true } },
	latex = {
		enabled = true,
		position = "center",
		top_pad = 0,
		bottom_pad = 0,
	},
})

vim.keymap.set("n", "<leader>m", ":lua require('render-markdown').toggle()<CR>", {})
