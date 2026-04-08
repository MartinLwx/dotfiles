vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim", name = "conform" },
})
require("conform").setup({
	-- NOTE: Install formatters with Mason
	formatters_by_ft = {
		-- Specify the linter for each programming language.
		lua = { "stylua" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		ocaml = { "ocamlformat" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		clojure = { "cljfmt" },
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
})
