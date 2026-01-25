{ config, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
    pkgs.neovim # Text Editor
    pkgs.tldr # Command cheatsheet
    pkgs.tmux # Session manager
    pkgs.nixfmt # The .nix files formatter

    pkgs.darwin.trash
    pkgs.iina
  ];

  # Envionrment variables
  environment.variables = {
    EDITOR = "nvim";
  };

  services = {
    # PostgreSQL
    postgresql = {
      enable = true;
      dataDir = "/var/lib/postgresql";
      # FIXME: We still need to create database manually.
      initdbArgs = [ "--username=martinlwx" ];
    };
  };

  # WARN: As the time of writing, the initialScript, ensureDatabases, or ensureUsers
  #       are still unavailable.
  # workaround: https://github.com/nix-darwin/nix-darwin/issues/339
  system.activationScripts.preActivation = {
    # Generate this file!
    enable = true;
    # The file content
    text = ''
      if [ ! -d "/var/lib/postgresql" ]; then
        echo "creating PostgreSQL data directory..."
        sudo mkdir -m 750 -p /var/lib/postgresql
        chown -R martinlwx:staff /var/lib/postgresql
      fi
    '';
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

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
      # # Narrow the space between status icons in the menu bar
      # NSStatusItemSpacing = 8;
    };
    screencapture.location = "~/Documents/images";
  };
}
