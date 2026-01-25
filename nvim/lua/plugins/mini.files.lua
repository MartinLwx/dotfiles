return {
	"nvim-mini/mini.files",
	version = "*",
	config = function()
		require("mini.files").setup({})

		-- Default leader key: \
		vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", opts)
	end,
}
