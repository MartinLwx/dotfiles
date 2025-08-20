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
    pkgs.delta  # Better git diff

    # Program analysis tools
    pkgs.tree-sitter
    pkgs.semgrep
    pkgs.yara-x

    # Performance profiling
    pkgs.hyperfine

    # Utils
    pkgs.graphviz # The .dot visualizer
    pkgs.ripgrep # Better grep
    pkgs.fd # Better find
    pkgs.autojump # Cd command that learns

    # Blog writing
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

  # General shellAliases
  # You should put simple aliases that are compatible across all shells.
  home.shellAliases = {
    mv = "mv -i";
    mkdir = "mkdir -p";
    rm = "rm -i";
    v = "nvim";
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
