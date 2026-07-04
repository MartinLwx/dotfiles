vim.pack.add({
	{ src = "https://github.com/esmuellert/codediff.nvim", name = "codediff" },
})
require("codediff").setup()
vim.keymap.set("n", "<leader>gd", ":CodeDiff<CR>", {})
vim.keymap.set("n", "<leader>gf", ":CodeDiff file HEAD<CR>", {})
