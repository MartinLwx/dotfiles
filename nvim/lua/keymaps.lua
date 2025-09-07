-- Define common options
local opts = {
	noremap = true, -- non-recursive
	silent = true, -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Open mini.files navigation
-- Default leader key: \
vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", opts)

-- Open CodeCompanion.nvim
vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionChat Toggle<CR>", opts)

-- For conjure
vim.g.maplocalleader = ","

-- For flash.nvim
-- 1. Press `s` and type jump label
-- 2. Press `S` and type jump label for specefic selection based on tree-sitter.
--    You can also use `;` or `,` to increase/decrease the selection

-- For nvim-surround
--     Old text                    Command         New text
-- --------------------------------------------------------------------------------
--     surr*ound_words             ysiw)           (surround_words)
--     *make strings               ys$"            "make strings"
--     [delete ar*ound me!]        ds]             delete around me!
--     remove <b>HTML t*ags</b>    dst             remove HTML tags
--     'change quot*es'            cs'"            "change quotes"
--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- For nvim-treesitter
-- 1. Press `gss` to intialize selection. (ss = start selection)
-- 2. Now we are in the visual mode.
-- 3. Press `gsi` to increment selection by AST node. (si = selection incremental)
-- 4. Press `gsc` to increment selection by scope. (sc = scope)
-- 5. Press `gsd` to decrement selection. (sd = selection decrement)
