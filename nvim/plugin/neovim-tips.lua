vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/saxon1964/neovim-tips", name = "neovim_tips" },
})
require("neovim_tips").setup({
	-- IMPORTANT: Daily tip DOES NOT WORK with lazy = true
	-- Reason: lazy = true loads plugin only when keybinds are triggered,
	--         but daily_tip needs plugin loaded at startup
	-- Solution: Keep daily_tip = 0 here, or use Option 2 below for daily tips
	daily_tip = 1, -- 0 = off, 1 = once per day, 2 = every startup
	-- Other optional settings...
	bookmark_symbol = "🌟 ",
})

vim.keymap.set("n", "<leader>nto", ":NeovimTips<CR>", { desc = "Neovim tips", silent = true })
vim.keymap.set("n", "<leader>ntb", ":NeovimTipsBookmarks<CR>", { desc = "Bookmarked tips" })
