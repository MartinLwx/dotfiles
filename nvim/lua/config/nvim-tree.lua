local is_ok, nvim_tree = pcall(require, 'nvim-tree')
if not is_ok then
    return
end

-- Hint: :help nvim-tree-default-mappings
-- setup with some options
nvim_tree.setup({
    sort_by     = "case_sensitive",
    view        = {
        width = 30,
        side = 'left',
        mappings = {
            list = {
                { key = 'u', action = 'dir_up' },
                { key = 'o', action = 'edit' }, -- edit rather than edit_in_plac
                { key = 'h', action = 'close_node' },
                { key = 'v', action = 'vsplit' },
            },
        },
    },
    renderer    = {
        group_empty = true,
    },
    filters     = {
        dotfiles = true,
    },
    diagnostics = {
        enable = true,
    },
})
