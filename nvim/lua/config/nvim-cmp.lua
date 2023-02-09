local cmp = require("cmp")

local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- Use <C-b/f> to scroll the docs
        ['<C-b>'] = cmp.mapping.scroll_docs( -4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Use <C-k/j> to switch in items
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        -- Use <CR>(Enter) to confirm selection
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        -- A super tab
        -- source: https://github.com/LunarVim/LunarVim/blob/277079ff453fcd951447110fbc745e2241e0490f/lua/lvim/core/cmp.lua
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- Hint: if the completion menu is visible select next one
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif jumpable(1) then
                luasnip.jump(1)
            elseif has_words_before() then
                -- cmp.complete()
                fallback()
            else
                fallback()
            end
        end, { "i", "s" }), -- i - insert mode; s - selction mode
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable( -1) then
                luasnip.jump( -1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    -- Let's configure the item's appearance
    -- source: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
    formatting = {
        -- customize the appearance of the completion menu
        format = lspkind.cmp_format({
            -- show only symbol annotations
            mode = 'symbol_text',
            -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            maxwidth = 100,
            -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            ellipsis_char = '...',

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
                vim_item.menu = ({
                        nvim_lsp = '[Lsp]',
                        luasnip = '[Luasnip]',
                        buffer = '[File]',
                        path = '[Path]',
                    })[entry.source.name]
                return vim_item
            end,
        })
    },
    -- Set source precedence
    sources = cmp.config.sources({
        { name = 'nvim_lsp' }, -- For nvim-lsp
        { name = 'luasnip' }, -- For luasnip user
        { name = 'buffer' }, -- For buffer word completion
        { name = 'path' }, -- For path completion
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
