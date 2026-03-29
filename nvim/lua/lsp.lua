-- Remove global default key mapping
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")

-- Create new keymapping for lsps
-- LspAttach: After an LSP Client performs "initialize" and attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local keymap = vim.keymap
		local lsp = vim.lsp
		local bufopts = { noremap = true, silent = true }

		keymap.set("n", "gr", lsp.buf.references, bufopts)
		keymap.set("n", "gd", lsp.buf.definition, bufopts)
		keymap.set("n", "<space>rn", lsp.buf.rename, bufopts)
		keymap.set("n", "K", lsp.buf.hover, bufopts)
		keymap.set({ "n", "v" }, "<space>f", function()
			local mode = vim.api.nvim_get_mode().mode

			if vim.startswith(string.lower(mode), "v") then
				require("conform").format({ lsp_fallback = true, async = true, timeout_ms = 1000 }, function(err)
					if not err then
						if vim.startswith(string.lower(mode), "v") then
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
								"n",
								false
							)
						end
					end
				end)
			else
				require("conform").format({
					lsp_fallback = true,
					async = true,
					timeout_ms = 1000,
				})
			end
		end, bufopts)
	end,
})

vim.lsp.enable({
	"clangd",
	"clojure_lsp",
	"lua_ls",
	"ty",
	"ocamllsp",
	"fennel_language_server",
	"tinymist",
	"roc_ls",
	"rust_analyzer",
	"zls",
	"gopls",
})
