local is_ok, configs = pcall(require, "nvim-treesitter.configs")
if not is_ok then
	return
end

configs.setup({
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- outer: outer part
				-- inner: inner part
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
			},
			-- If you set this to `true` (default is `false`) then any textobject is
			-- extended to include preceding or succeeding whitespace. Succeeding
			-- whitespace has priority in order to act similarly to eg the built-in
			-- `ap`.
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * selection_mode: eg 'v'
			-- and should return true or false
			include_surrounding_whitespace = true,
		},
	},
	move = {
		enable = true,
		set_jumps = true, -- whether to set jumps in the jumplist
		goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = { query = "@class.outer", desc = "Next class start" },
			--
			-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
			["]o"] = "@loop.*", -- that is, ["]o"] = { query = { "@loop.inner", "@loop.outer" } }

			-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
			-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
			["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
		},
		goto_next_end = {
			["]M"] = "@function.outer",
			["]["] = "@class.outer",
		},
		goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
		},
		goto_previous_end = {
			["[M"] = "@function.outer",
			["[]"] = "@class.outer",
		},
		-- Below will go to either the start or the end, whichever is closer.
		-- Use if you want more granular movements
		-- Make it even more gradual by adding multiple queries and regex.
		goto_next = {
			["]d"] = "@conditional.outer",
		},
		goto_previous = {
			["[d"] = "@conditional.outer",
		},
	},
})
