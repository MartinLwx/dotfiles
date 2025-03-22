return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = function()
		require("config.nvim-treesitter-textobjects")
	end,
}
