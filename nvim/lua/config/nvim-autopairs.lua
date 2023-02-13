local is_ok, npairs = pcall(require, 'nvim-autopairs')
if not is_ok then
    return
end

npairs.setup({
    check_ts = true, -- check if treesitter is installed
    disable_filetype = { "TelescopePrompt", "vim" },
    ts_config = {
        lua = { 'string' }, -- it will not add a pair on that treesitter node
        javascript = { 'template_string' },
        java = false, -- don't check treesitter on java
    }
})

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)
