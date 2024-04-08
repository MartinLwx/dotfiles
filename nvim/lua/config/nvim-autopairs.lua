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
	check_ts = true, -- check if treesitter is installed
	ts_config = {
		lua = { "string" }, -- it will not add a pair on that treesitter node
		javascript = { "template_string" },
		java = false, -- don't check treesitter on java
	},
})
