vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.files", version = vim.version.range("*"), name = "mini.files" },
})
require("mini.files").setup({})

-- Default leader key: \
vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", opts)
