local is_ok, npairs = pcall(require, "nvim-autopairs")
if not is_ok then
	return
end

npairs.setup({
	disable_filetype = { "TelescopePrompt" },
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
})
