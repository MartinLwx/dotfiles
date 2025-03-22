-- Paste image from system clipboard by :PasteImage
-- As suggested by the official README.md, the pngpaste shoule be ins
-- Requirements (MacOS): pngpaste (optional, but recommended)
-- Requirements (Linux): xclip (x11) or wl-clipboard (wayland)
return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		default = {
			dir_path = "assets", -- save dir
			extension = "png",
			file_name = "%Y-%m-%d-%H-%M-%S",
			prompt_for_file_name = false,
		},
	},
	keys = {
		-- suggested keymap
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},
}
