vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons", name = "nvim-web-devicons" },
	{ src = "https://github.com/folke/trouble.nvim" },
})
-- Buffer diagnostics
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {
	desc = "Buffer Diagnostics (Trouble)",
})

-- Global diagnostics
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", {
	desc = "Diagnostics (Trouble)",
})

-- Symbols
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", {
	desc = "Symbols (Trouble)",
})

-- LSP (definitions / references / etc.)
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", {
	desc = "LSP Definitions / references / ... (Trouble)",
})

-- Location list
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", {
	desc = "Location List (Trouble)",
})

-- Quickfix list
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", {
	desc = "Quickfix List (Trouble)",
})
