-- Show indentation and blankline
vim.pack.add({
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim", name = "ibl" },
})
require("ibl").setup({})
