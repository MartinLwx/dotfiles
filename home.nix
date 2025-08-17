# NOTE: The manual: https://nix-community.github.io/home-manager/
{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "martinlwx";

  # # Packages that should be installed to the user profile.
  # home.packages = [
  #   pkgs.neo4j   # Graph DB
  # ];
  # Git settings.
  programs.git = {
    enable = true;
    userName = "MartinLwx";
    userEmail = "MartinLwx@163.com";
  };

  # General shellAliases
  # You should put simple aliases that are compatible across all shells.
  home.shellAliases = {
    mv = "mv -i";
    mkdir = "mkdir -p";
    rm = "rm -i";
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
      plugins = ["git" "sudo"];
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
