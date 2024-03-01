local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end

local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
	return
end

local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_ok then
	return
end

-- Hint:

mason.setup()

mason_null_ls.setup({
	-- A list of sources to install if they're not already installed.
	-- This setting has no relation with the `automatic_installation` setting.
	ensure_installed = {
		"black",
		"stylua",
	},
	-- Run `require("null-ls").setup`.
	-- Will automatically install masons tools based on selected sources in `null-ls`.
	-- Can also be an exclusion list.
	-- Example: `automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }`
	automatic_installation = false,
	-- Sources found installed in mason will automatically be setup for null-ls.
	automatic_setup = true,
	handlers = {
		-- Hint: see https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
		--       to see what sources are available
		-- Hint: see https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
		--       to check what we can configure for each source
		-- function() end, -- disables automatic setup of all null-ls sources
		black = function(source_name, methods)
			null_ls.register(null_ls.builtins.formatting.black)
		end,
		stylua = function(source_name, methods)
			null_ls.register(null_ls.builtins.formatting.stylua)
		end,
		ocamlformat = function(source_name, methods)
			null_ls.register(null_ls.builtins.formatting.ocamlformat.with({
				-- Add more arguments to a source's defaults
				-- Default: { "--enable-outside-detected-project", "--name", "$FILENAME", "-" }
				-- Type `ocamlformat --help` in your terminal to check more args
				extra_args = {
					"--if-then-else",
					"vertical",
					"--break-cases",
					"fit-or-vertical",
					"--type-decl",
					"sparse",
				},
			}))
		end,
	},
})

null_ls.setup()
