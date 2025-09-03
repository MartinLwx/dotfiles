return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-mini/mini.icons" },
	config = function()
		require("fzf-lua").setup()
		vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "Search over files" })
		vim.keymap.set("n", "<leader>flg", require("fzf-lua").live_grep, { desc = "Search over fiile contents" })
		vim.keymap.set("n", "<leader>fr", require("fzf-lua").resume, { desc = "Resume fzf-lua" })
		vim.keymap.set("n", "<leader>fg", require("fzf-lua").git_files, { desc = "Resume fzf-lua" })
	end,
}
