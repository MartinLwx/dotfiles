vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim", name = "gitsigns" },
})
require("gitsigns").setup()

-- NOTE: The gh here stangs for git hunk
vim.keymap.set("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", {})
vim.keymap.set("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", {}) -- Stage or Unstage
vim.keymap.set("n", "<leader>h!", ":Gitsigns reset_hunk<CR>", {}) -- Can only reset unstaged content
vim.keymap.set("n", "<leader>hn", ":Gitsigns nav_hunk next<CR>", {})
