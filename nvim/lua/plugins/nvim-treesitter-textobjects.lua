return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = "nvim-treesitter/nvim-treesitter",
	init = function()
		-- Disable entire built-in ftplugin mappings to avoid conflicts.
		-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
		vim.g.no_plugin_maps = true
	end,
	config = function()
		require("nvim-treesitter-textobjects", 123, 45).setup({
			select = {
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
				-- If you set this to `true` (default is `false`) then any textobject is
				-- extended to include preceding or succeeding whitespace. Succeeding
				-- whitespace has priority in order to act similarly to eg the built-in
				-- `ap`.
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * selection_mode: eg 'v'
				-- and should return true or false
				include_surrounding_whitespace = false,
			},
			move = {
				-- whether to set jumps in the jumplist
				set_jumps = true,
			},
		})
		-- Select function/methods and class
		vim.keymap.set({ "x", "o" }, "af", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
		end)
		vim.keymap.set({ "x", "o" }, "if", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
		end)
		vim.keymap.set({ "x", "o" }, "ac", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
		end)
		vim.keymap.set({ "x", "o" }, "ic", function()
			require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
		end)
		-- Swap function parameters
		vim.keymap.set("n", "<localleader>>p", function()
			require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
		end)
		vim.keymap.set("n", "<localleader><p", function()
			require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
		end)
		-- Swap functions
		vim.keymap.set("n", "<localleader>>f", function()
			require("nvim-treesitter-textobjects.swap").swap_next("@function.outer")
		end)
		vim.keymap.set("n", "<localleader><f", function()
			require("nvim-treesitter-textobjects.swap").swap_previous("@function.outer")
		end)
		-- Move
		vim.keymap.set({ "n", "x", "o" }, "]m", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
		end)
		vim.keymap.set({ "n", "x", "o" }, "]]", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
		end)
		-- Move
		vim.keymap.set({ "n", "x", "o" }, "]m", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
		end)
		vim.keymap.set({ "n", "x", "o" }, "]]", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
		end)
		vim.keymap.set({ "n", "x", "o" }, "[m", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
		end)
		vim.keymap.set({ "n", "x", "o" }, "[[", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
		end)
	end,
}
