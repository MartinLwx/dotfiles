local is_ok, indent_blankline = pcall(require, "ibl")
if not is_ok then
	return
end

-- For all available options, take a look at `:help ibl.config.`
indent_blankline.setup()
