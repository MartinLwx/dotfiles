require("mason").setup()
require("mason-null-ls").setup({
    -- A list of sources to install if they're not already installed.
    -- This setting has no relation with the `automatic_installation` setting.
    ensure_installed = {
        -- Opt to list sources here, when available in mason.
        'black', 'stylua'
    },
    automatic_installation = false,
    -- Sources found installed in mason will automatically be setup for null-ls.
    automatic_setup = true,
    handlers = {},
})
require("null-ls").setup({
    sources = {
        -- Anything not supported by mason.
    }
})
