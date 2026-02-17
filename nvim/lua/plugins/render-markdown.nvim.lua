return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	ft = { "markdown" },

	config = function()
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
	end,
}
