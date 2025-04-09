return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },
		disable_in_macro = true, -- disable when recording or executing a macro
        -- Explanation of map_cr
		-- Before        Input         After
		-- ------------------------------------
		-- {|}           <CR>          {
		--                                 |
		--                             }
		-- ------------------------------------
		map_cr = true,
		check_ts = true, -- check if tree-sitter is installed
		ts_config = {
			lua = { "string" }, -- it will not add a pair on that tree-sitter node
			javascript = { "template_string" },
			java = false, -- don't check tree-sitter on java
		},
	},
}
