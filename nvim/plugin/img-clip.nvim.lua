-- Paste image from system clipboard by :PasteImage
-- As suggested by the official README.md, the pngpaste shoule be installed
-- Requirements (MacOS): pngpaste (optional, but recommended)
-- Requirements (Linux): xclip (x11) or wl-clipboard (wayland)
vim.pack.add({
	{ src = "https://github.com/HakonHarnes/img-clip.nvim" },
})
require("img-clip").setup({
	default = {
		dir_path = "assets", -- save dir
		extension = "png",
		file_name = "%Y-%m-%d-%H-%M-%S",
		prompt_for_file_name = false,
	},
})
vim.keymap.set({ "n" }, "<leader>p", "<cmd>PasteImage<cr>", { desc = "Paste image from system clipboard" })
