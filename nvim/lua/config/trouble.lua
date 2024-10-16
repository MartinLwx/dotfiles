local is_ok, trouble = pcall(require, "trouble")
if not is_ok then
	return
end

trouble.setup({
	auto_close = false, -- auto close when there are no items
	auto_open = false, -- auto open when there are items
	auto_preview = true, -- automatically open preview when on an item
	auto_refresh = true, -- auto refresh when open
	focus = false, -- Focus the window when opened
	restore = true, -- restores the last location in the list when opening
	follow = true, -- Follow the current item
	indent_guides = true, -- show indent guides
	max_items = 200, -- limit number of items that can be displayed per section
	multiline = true, -- render multi-line messages
	pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
	keys = {
		["?"] = "help",
		r = "refresh",
		R = "toggle_refresh",
		q = "close",
		o = "jump_close",
		["<esc>"] = "cancel",
		["<cr>"] = "jump",
		["<2-leftmouse>"] = "jump",
		["<c-s>"] = "jump_split",
		["<c-v>"] = "jump_vsplit",
		-- go down to the next item (accepts count)
		-- j = "next",
		["}"] = "next",
		["]]"] = "next",
		-- go up to the prev item (accepts count)
		-- k = "prev",
		["{"] = "prev",
		["[["] = "prev",
		i = "inspect",
		p = "preview",
		P = "toggle_preview",
		zo = "fold_open",
		zO = "fold_open_recursive",
		zc = "fold_close",
		zC = "fold_close_recursive",
		za = "fold_toggle",
		zA = "fold_toggle_recursive",
		zm = "fold_more",
		zM = "fold_close_all",
		zr = "fold_reduce",
		zR = "fold_open_all",
		zx = "fold_update",
		zX = "fold_update_all",
		zn = "fold_disable",
		zN = "fold_enable",
		zi = "fold_toggle_enable",
	},
	modes = {
		symbols = {
			desc = "document symbols",
			mode = "lsp_document_symbols",
			focus = false,
			win = { position = "right" },
			filter = {
				-- Remove Package since luals uses it for control flow structures
				["not"] = { ft = "lua", kind = "Package" },
				any = {
					-- all symbol kinds for help / markdown files
					ft = { "help", "markdown" },
					-- default set of symbol kinds
					kind = {
						"Class",
						"Constructor",
						"Enum",
						"Field",
						"Function",
						"Interface",
						"Method",
						"Module",
						"Namespace",
						"Package",
						"Property",
						"Struct",
						"Trait",
					},
				},
			},
		},
	},
})
