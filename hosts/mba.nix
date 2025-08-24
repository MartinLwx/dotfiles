{ config, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
    pkgs.neovim # Text Editor
    pkgs.tree # Produce a depth indented directory listing
    pkgs.tldr # Command cheatsheet
    pkgs.ncdu # Disk usage analyzer
    pkgs.tmux # Session manager
    pkgs.nixfmt-rfc-style # The .nix files formatter
  ];

  # Envionrment Variables
  environment.variables = {
    EDITOR = "nvim";
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable Touch ID and Apple Watch with sudo.
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS system settings
  system.primaryUser = "martinlwx";
  system.defaults = {
    # Menu bar settings.
    controlcenter = {
      BatteryShowPercentage = false;
    };
    # Dock settings.
    dock = {
      autohide = false;
    };
    # Finder settings.
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # Column View
    };
    NSGlobalDomain = {
      # Do not automatically switch between light and dark mode
      AppleInterfaceStyleSwitchesAutomatically = false;
    };
    screencapture.location = "~/Documents/images";
  };
}
