vim.pack.add({
	{ src = "https://github.com/esmuellert/codediff.nvim", name = "codediff" },
	{ src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
	{ src = "https://github.com/NeogitOrg/neogit", name = "neogit" },
})
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", {})
