local cmp_ok, cmp = pcall(require, "cmp")
local lspkind_ok, lspkind = pcall(require, "lspkind")

if not cmp_ok or not lspkind_ok then
	return
end

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- WARNING: This feature requires Neovim v0.10+
			vim.snippet.expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		-- Use <C-b/f> to scroll the docs.
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		-- Use <C-k/j> to switch in items.
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		-- Use <CR> to confirm selection.
		-- Set select to false to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- A super tab
		["<Tab>"] = cmp.mapping(function(fallback)
			-- Hint: if the completion menu is visible select the next one
			if cmp.visible() then
				cmp.select_next_item()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }), -- i - insert mode; s - select mode
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
				fallback()
			end
		end, { "i", "s" }),
	}),
	-- Let's configure the item's appearance
	-- source: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
	formatting = {
		-- Customize the appearance of the completion menu
		format = lspkind.cmp_format({
			-- Show only symbol annotations
			mode = "symbol_text",
			-- Prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			maxwidth = 100,
			-- When the popup menu exceeds maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			ellipsis_char = "...",

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			before = function(entry, vim_item)
				vim_item.menu = ({
					nvim_lsp = "[Lsp]",
					buffer = "[File]",
					path = "[Path]",
				})[entry.source.name]
				return vim_item
			end,
		}),
	},
	-- Set source precedence
	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- For nvim-lsp
		{ name = "buffer" }, -- For buffer word completion
		{ name = "path" }, -- For path completion
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
