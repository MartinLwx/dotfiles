return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000, -- ensure that the colortheme is loaded first
	opts = {
		saturation = 0.8,
		variant = "auto", -- set dark or light colors based on the current value of `vim.o.background`
	},
}
