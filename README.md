## Motivations
> [*Your dotfiles will most likely be the longest project you ever worked on.*](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/)

Managing dotfiles without a version control system is a chore. That's why I created this GitHub repo :)

## Structure of my dotfiles

```
.
├── flake.lock
├── flake.nix
├── lib                 # utils for Nix
├── hosts               # hosts (aka. machines) configurations
├── users               # user-level configurations
├── hammerspoon         # hammerspoon configurations
├── kitty               # keymapping configurations
├── nvim                # neovim configurations
├── README.md
└── windows-only        # Windows configurations

```
## What is inside?
### Kitty
My Personal Kitty Configurations
### Hammerspoon
I use [Hammerspoon](https://www.hammerspoon.org/) to manage windows. The available key mappings are:
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
    - LSP registry: [mason.nvim](https://github.com/williamboman/mason.nvim)
- Git related
    - Git integration: [vim-fugitive](https://github.com/tpope/vim-fugitive)
    - Git decorations: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- Typst tools: [tinymist](https://github.com/Myriad-Dreamin/tinymist?tab=readme-ov-file)
- Markdown tools:
    - Markdown: [vim-markdown](https://github.com/preservim/vim-markdown)
    - Markdown previewer (in browser): [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
    - Markdown previewer (within file): [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
    - Paste image : [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim)
- Stylish
    - Colorscheme: [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
    - Better UI for messages/cmdline/popupmenu: [noice.nvim](https://github.com/folke/noice.nvim)
    - TODO highlighting: [todo-comments.nvim](https://github.com/folke/todo-comments.nvim?tab=readme-ov-file)
- Code editing
    - General capability
        - Treesitter integration: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
        - Show context at the top: [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)
        - Syntax aware text-object: [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
        - A pretty list for showing diagnostics: [trouble.nvim](https://github.com/folke/trouble.nvim)
        - Indentation indicator: [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)
        - Easy motion: [flash.nvim](https://github.com/folke/flash.nvim)
        - Surrounding: [nvim-surround](https://github.com/kylechui/nvim-surround)
        - CodeCompanion: [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim)
        - Linter: [nvim-lint](https://github.com/mfussenegger/nvim-lint)
        - Colorful delimiters: [rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)
        - Formatter: [conform.nvim](https://github.com/stevearc/conform.nvim)
        - REPL-Driven Development: [conjure](https://github.com/Olical/conjure)
        - Make tracing function call easier: [overlook.nvim](https://github.com/WilliamHsieh/overlook.nvim/)
    - Lisp kind
        - nvim-parinfer: [nvim-parinfer](https://github.com/gpanders/nvim-parinfer)
- Integration
    - Use `c-h/j/k/l` consistently: [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- Fuzzy finders: [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- File explorer: [mini.files](https://github.com/echasnovski/mini.files)
- Status line: [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- Editor Performance: [faster.nvim](https://github.com/pteroctopus/faster.nvim)
### Windows-only
I use Mac for personal business *but* use a Windows PC at work, so I wrote the `keymappings.ahk` to map keys between Mac and Windows to keep a consistent muscle memory. To use this `.ahk` script, you need to install the [AutoHotKey](https://www.autohotkey.com/) tool and run `keymappings.ahk` *as administrator*. Besides that, you *should* install a third-party Chinese IME and delete the built-in Microsoft Pinyin IME *if* you are also a Chinese user because there is an unfixed [issue](https://answers.microsoft.com/en-us/windows/forum/all/how-to-completely-disable-the-english-mode-in/2dadd3c1-e441-4e35-8049-dbcb5d50fdfc).
### nix-darwin
I have been *gradually* migrating to Nix flakes because I really appreciate the reproducibility they offer. My Nix configuration structure is largely inspired by [mitchellh' nixos-config](https://github.com/mitchellh/nixos-config).
## Appendix
- [Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml)
- [The nix-darwin Configuration Options](https://nix-darwin.github.io/nix-darwin/manual/)
