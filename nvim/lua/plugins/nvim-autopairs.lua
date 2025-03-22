return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("config.nvim-autopairs")
	end,
}
