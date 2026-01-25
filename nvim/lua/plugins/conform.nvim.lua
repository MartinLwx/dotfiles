return {
	"stevearc/conform.nvim",
	opts = {
		-- NOTE: Install formatters with Mason
		formatters_by_ft = {
			-- Specify the linter for each programming language.
			lua = { "stylua" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			ocaml = { "ocamlformat" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			elixir = { "elixir-ls" },
			julia = { "jupytext" },
			clojure = { "cljfmt" },
			fsharp = { "fantomas" },
			python = function(bufnr)
				if require("conform").get_formatter_info("ruff_format", bufnr).available then
					-- Conform will run multiple formatters sequentially
					return { "isort", "ruff_format" }
				else
					-- Conform will run multiple formatters sequentially
					return { "isort", "black" }
				end
			end,
		},
		-- NOTE: You can customize each formatter just like this.
		formatters = {
			ocamlformat = {
				prepend_args = {
					"--if-then-else",
					"vertical",
					"--break-cases",
					"fit-or-vertical",
					"--type-decl",
					"sparse",
				},
			},
		},
	},
}
