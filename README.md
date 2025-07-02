## Motivations
> [*Your dotfiles will most likely be the longest project you ever worked on.*](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/)

Managing dotfiles without a version control system is a chore. That's why I created this GitHub repo :)

## What is inside?
### Kitty
My Personal Kitty Configurations
### Hammerspoon
I use the [Hammerspoon](https://www.hammerspoon.org/) to manage windows. The available keymappings are:
- Full screen  - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>f</kdb>
- Center       - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>c</kdb>
- Left half    - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>←</kdb>
- Right half   - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>→</kdb>
- Top half     - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>↑</kdb>
- Bottom half  - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>↓</kdb>
- Top left     - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>⌃ Control</kbd> + <kbd>u</kdb>
- Top right    - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>⌃ Control</kbd> + <kbd>i</kdb>
- Bottom left  - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>⌃ Control</kbd> + <kbd>j</kdb>
- Bottom right - <kbd>⌘ Command</kbd> + <kbd>⌥ Option</kbd> + <kbd>⌃ Control</kbd> + <kbd>k</kdb>
- Hold to quit any app - <kbd>⌘ Command</kbd> + <kbd>q</kbd>
### Neovim
My Go-to text editor with the following plugins:
- Package manager: [lazy.nvim](https://github.com/folke/lazy.nvim)
- Auto-completion 
    - Completion sources: [blink.cmp](https://github.com/saghen/blink.cmp)
    - Vscode-like pictograms: [lspkind.nvim](https://github.com/onsails/lspkind.nvim)
    - LSP support:
        - [mason.nvim](https://github.com/williamboman/mason.nvim)
        - [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
        - [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- Git related
    - Git integration: [vim-fugitive](https://github.com/tpope/vim-fugitive)
    - Git decorations: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- Typst tools: [tinymist](https://github.com/Myriad-Dreamin/tinymist?tab=readme-ov-file)
- Markdown tools:
    - Markdown: [vim-markdown](https://github.com/preservim/vim-markdown)
    - Markdown previewer: [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
    - Paste image : [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim)
- Programming languages:
    - Treesitter integration: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
    - Show context at the top: [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)
    - Syntax aware text-object: [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- Stylish
    - Colorscheme: [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
    - Better UI for messages/cmdline/popupmenu: [noice.nvim](https://github.com/folke/noice.nvim)
    - TODO highlighting: [todo-comments.nvim](https://github.com/folke/todo-comments.nvim?tab=readme-ov-file)
- Code editing
    - A pretty list for showing diagnostics: [trouble.nvim](https://github.com/folke/trouble.nvim)
    - Autopairs: [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
    - Indentation indicator: [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)
    - Easy motion: [flash.nvim](https://github.com/folke/flash.nvim)
    - Surrounding: [nvim-surround](https://github.com/kylechui/nvim-surround)
    - CodeCompanion: [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)
    - Linter: [nvim-lint](https://github.com/mfussenegger/nvim-lint)
    - Formatter: [conform.nvim](https://github.com/stevearc/conform.nvim)
- Fuzzy finders: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- File explorer: [mini.files](https://github.com/echasnovski/mini.files)
- Status line: [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- Better terminal support: [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- Editor Performance: [faster.nvim](https://github.com/pteroctopus/faster.nvim)

### Windows-only
I use Mac for personal business *but* use a Windows PC at work, so I wrote the `keymappings.ahk` to map keys between Mac and Windows to keep a consistent muscle memory. To use this `.ahk` script, you need to install the [AutoHotKey](https://www.autohotkey.com/) tool and run `keymappings.ahk` *as administrator*. Besides that, you *should* install a third-party Chinese IME and delete the built-in Microsoft Pinyin IME *if* you are also a Chinese user because there is an unfixed [issue](https://answers.microsoft.com/en-us/windows/forum/all/how-to-completely-disable-the-english-mode-in/2dadd3c1-e441-4e35-8049-dbcb5d50fdfc).
