return {
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup()
		vim.keymap.set("n", "<leader>gd", ":DiffviewOpen -uno<CR>", {})
		vim.keymap.set("n", "<leader>gf", ":DiffviewFileHistory %<CR>", {})
		vim.keymap.set("n", "<leader>gq", ":DiffviewClose<CR>", {})
	end,
}
