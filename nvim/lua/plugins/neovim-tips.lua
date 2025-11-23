return {
	"saxon1964/neovim-tips",
	version = "*", -- Only update on tagged releases
	lazy = false, -- Load only when keybinds are triggered
	dependencies = {
		"MeanderingProgrammer/render-markdown.nvim",
	},
	opts = {
		-- IMPORTANT: Daily tip DOES NOT WORK with lazy = true
		-- Reason: lazy = true loads plugin only when keybinds are triggered,
		--         but daily_tip needs plugin loaded at startup
		-- Solution: Keep daily_tip = 0 here, or use Option 2 below for daily tips
		daily_tip = 1, -- 0 = off, 1 = once per day, 2 = every startup
		-- Other optional settings...
		bookmark_symbol = "🌟 ",
	},
	init = function()
		-- OPTIONAL: Change to your liking or drop completely
		-- The plugin does not provide default key mappings, only commands
		vim.keymap.set("n", "<leader>ft", ":NeovimTips<CR>", { desc = "Neovim tips", silent = true })
	end,
}
