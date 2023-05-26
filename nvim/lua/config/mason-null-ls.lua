require("mason").setup()
local null_ls = require("null-ls")

local sources = {
	null_ls.builtins.formatting.black.with({ extra_args = { "--target-version", "py310" } }),
	null_ls.builtins.formatting.stylua,
}

null_ls.setup({
	debug = false,
	log_level = "warn",
	update_in_insert = false,
	sources = sources,
})

require("mason-null-ls").setup({
	-- A list of sources to install if they're not already installed.
	-- This setting has no relation with the `automatic_installation` setting.
	ensure_installed = {
		"black",
		"stylua",
	},
	automatic_installation = false,
	-- Sources found installed in mason will automatically be setup for null-ls.
	automatic_setup = true,
	handlers = {},
})
