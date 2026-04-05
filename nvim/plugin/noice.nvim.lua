-- Run `:checkhealth noice` to check for common issues
vim.pack.add({
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/folke/noice.nvim", name = "noice" },
})
require("noice").setup()
