local is_ok, builtin = pcall(require, "telescope.builtin")
if not is_ok then
	return
end

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {}) -- i.e. previously open files
vim.keymap.set("n", "<leader>fc", function() -- fc = find by command
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
