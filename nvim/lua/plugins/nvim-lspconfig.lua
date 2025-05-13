return {
    "neovim/nvim-lspconfig",

    -- How to add an LSP for a specific programming language?
    -- 1. Use `:Mason` to install the corresponding LSP.
    -- 2. Add the configuration below. The syntax is `lspconfig.<name>.setup(...)`
    -- Hint (find <name> here): https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    config = function ()
        -- Set different settings for different languages' LSP.
        -- Support List: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        local lspconfig = require("lspconfig")

        -- Case 1. For CMake Users
        --     $ cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
        -- Case 2. For Bazel Users, use https://github.com/hedronvision/bazel-compile-commands-extractor
        -- Case 3. If you don't use any build tool and all files in a project use the same build flags
        --     Place your compiler flags in the compile_flags.txt file, located in the root directory
        --     of your project. Each line in the file should contain a single compiler flag.
        -- src: https://clangd.llvm.org/installation#compile_commandsjson
        lspconfig.clangd.setup({})
        lspconfig.gopls.setup({})
        lspconfig.bashls.setup({})
        lspconfig.rust_analyzer.setup({})
        lspconfig.hls.setup({})
        lspconfig.ocamllsp.setup({})
        lspconfig.ruby_lsp.setup({})
        -- src: https://docs.astral.sh/ruff/editors/setup/#neovim
        lspconfig.ruff.setup({})
        lspconfig.ts_ls.setup({})
        lspconfig.elixirls.setup({})
        lspconfig.tinymist.setup({
            settings = {
                formatterMode = "typstyle",
                exportPdf = "onType",
                semanticTokens = "disable",
            },
        })
        lspconfig.pylsp.setup({
            settings = {
                -- configure plugins in pylsp
                pylsp = {
                    plugins = {
                        pyflakes = { enabled = false },
                        pylint = { enabled = false },
                        pycodestyle = { enabled = false },
                    },
                },
            },
        })
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim).
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global.
                        globals = { "vim" },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files.
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier.
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
    end
}
