vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons", name = "mini.icons" },
	{ src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
})
require("fzf-lua").setup()
vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "Search over files" })
vim.keymap.set("n", "<leader>fg", require("fzf-lua").git_files, { desc = "Search over git files" })
vim.keymap.set("n", "<leader>fc", require("fzf-lua").live_grep_native, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fr", require("fzf-lua").resume, { desc = "Resume fzf-lua" })
