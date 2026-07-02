vim.pack.add({
	"https://github.com/Owen-Dechow/videre.nvim",
	"https://github.com/Owen-Dechow/graph_view_yaml_parser", -- Optional: add YAML support
	"https://github.com/Owen-Dechow/graph_view_toml_parser", -- Optional: add TOML support
	"https://github.com/a-usr/xml2lua.nvim", -- Optional | Experimental: add XML support
})

require("videre").setup({
	box_style = "sharp",
})
