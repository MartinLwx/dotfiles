return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt", lsp_format = "fallback" },
			ocaml = { "ocamlformat" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			python = function(bufnr)
				if require("conform").get_formatter_info("ruff_format", bufnr).available then
					return { "ruff_format" }
				else
					return { "black" }
				end
			end,
		},
		formatters = {
			ocamlformat = {
				command = "ocamlformat",
				args = {
					"--if-then-else",
					"vertical",
					"--break-cases",
					"fit-or-vertical",
					"--type-decl",
					"sparse",
					-- $FILENAME - absolute path to the file
					"$FILENAME",
				},
			},
		},
	},
}
