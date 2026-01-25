-- Status line
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		-- -- Lualine has sections as shown below.
		-- +-------------------------------------------------+
		-- | A | B | C                             X | Y | Z |
		-- +-------------------------------------------------+
		-- Each section holds its components
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = {
				{
					"filename",
					file_status = true, -- Displays file status (readonly status, modified status)
					path = 3, -- 0: Just the filename
					-- 1: Relative path
					-- 2: Absolute path
					-- 3: Absolute path, with tilde as the home directory
					-- 4: Filename and parent dir, with tilde as the home directory
					symbols = {
						modified = "[+]", -- Text to show when the file is modified.
						readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
						unnamed = "[No Name]", -- Text to show for unnamed buffers.
						newfile = "[New]", -- Text to show for newly created file before first write
					},
				},
			},
			lualine_x = {
				{
					"lsp_status",
					icon = "", -- f013
					symbols = {
						-- Standard unicode symbols to cycle through for LSP progress:
						spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
						-- Standard unicode symbol for when LSP is done:
						done = "✓",
						-- Delimiter inserted between LSP names:
						separator = " ",
					},
					-- List of LSP names to ignore (e.g., `null-ls`):
					ignore_lsp = {},
					-- Display the LSP name
					show_name = true,
				},
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
