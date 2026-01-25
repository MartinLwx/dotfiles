return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup()

		-- NOTE: The gh here stangs for git hunk
		vim.keymap.set("n", "<leader>ghp", ":Gitsigns preview_hunk<CR>", {})
		vim.keymap.set("n", "<leader>ghs", ":Gitsigns stage_hunk<CR>", {}) -- Stage or Unstage
		vim.keymap.set("n", "<leader>gh!", ":Gitsigns reset_hunk<CR>", {}) -- Can only reset unstaged content
		vim.keymap.set("n", "<leader>ghn", ":Gitsigns nav_hunk next<CR>", {})
	end,
}
