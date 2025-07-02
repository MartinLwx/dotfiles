return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")

		-- NOTE: Install formatters with Mason
		lint.linters_by_ft = {
			python = { "mypy" },
		}

		-- When to trigger lint? I bind it to some events as follows:
		--   BufEnter: enter a buffer.
		--   BufWritePost: save a buffer.
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
