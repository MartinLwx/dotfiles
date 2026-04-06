vim.pack.add({
	"https://github.com/folke/flash.nvim",
})
require("flash").setup()
-- Flash: s
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump({
		search = { forward = true, wrap = false, multi_window = false },
	})
end, { desc = "Flash" })

-- Flash Treesitter: S
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })
