vim.pack.add({
	{ src = "https://github.com/sindrets/diffview.nvim", name = "diffview" },
})
require("diffview").setup()
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen -uno<CR>", {})
vim.keymap.set("n", "<leader>gf", ":DiffviewFileHistory %<CR>", {})
vim.keymap.set("n", "<leader>gq", ":DiffviewClose<CR>", {})
