{ inputs }:

{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Packages that should be installed to the user profile.
  home.packages = [
    # JavaScript
    pkgs.nodejs

    # Clojure
    pkgs.clojure

    # Python
    pkgs.uv # Better pip

    # OCaml
    pkgs.ocaml
    pkgs.opam # OCaml package manager

    # Rust
    pkgs.cargo # Rust package manager
    pkgs.rustc

    # Databases
    pkgs.neo4j
    pkgs.postgresql

    # Git
    pkgs.git
    pkgs.gitmoji-cli
    pkgs.delta # Better git diff

    # Program analysis tools
    pkgs.tree-sitter
    pkgs.semgrep
    pkgs.yara-x

    # Performance profiling
    pkgs.hyperfine

    # Utils
    pkgs.graphviz # The .dot visualizer
    pkgs.autojump # Cd command that learns

    # Modern CLI
    pkgs.aria2 # wget & curl
    pkgs.bat # cat
    pkgs.btop # top
    pkgs.duf # df
    pkgs.eza # ls
    pkgs.ripgrep # grep
    pkgs.fd # fd
    pkgs.gdu # du
    pkgs.fzf

    # Writing
    pkgs.hugo

    # Misc
    pkgs.direnv
    pkgs.neofetch
    pkgs.yt-dlp
  ];

  # Git settings.
  programs.git = {
    enable = true;
    userName = "MartinLwx";
    userEmail = "MartinLwx@163.com";
    delta = {
      # Enable the delta syntax highlighter.
      enable = true;
    };
  };

  programs.eza = {
    enable = true;
    colors = "auto";
    icons = "auto";
  };

  # General shellAliases
  # You should put simple aliases that are compatible across all shells.
  home.shellAliases = {
    mv = "mv -i";
    mkdir = "mkdir -p";
    rm = "rm -i";
    v = "nvim";
    cat = "bat --paging=never";
    ls = "eza";
    ll = "eza -l";
    tree = "eza --tree";
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../../";
  };

  # Zsh settings.
  # See: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
      ];
    };
  };

  # Tmux settings.
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 1;
    keyMode = "vi";
    mouse = false;
    prefix = "C-a";
    extraConfig = ''
      bind r source-file ~/.tmux.conf \; \
             display-message "Configrations reloaded"
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # See: https://github.com/christoomey/vim-tmux-navigator
      vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +''${vim_pattern}''$'"
      # -n = --no-prefix
      bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
      bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
      bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
      bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      bind C-s set-window-option synchronize-panes
      set -g default-terminal "tmux-256color"
      set -g window-status-current-style bg=grey
      set -w -g pane-border-lines heavy
    '';
  };

  # Autojump settings
  programs.autojump.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Ensure that the home-manager will be rebuilt with the nix-darwin generations.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
