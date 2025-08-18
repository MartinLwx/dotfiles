{
  description = "MartinLwx nix-darwin system flake";

  # The dependencies of this flake.nix.
  # Syntax: github:owner/name/reference
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # A Nix function whose parameters come from inputs.
  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      # See the full manual here: https://nix-darwin.github.io/nix-darwin/manual/

      # TODO: Replace martinlwx with your name.
      username = "martinlwx";
      configuration =
        { pkgs, ... }:
        {
          # WARN: To make home-manager work as expected, you need to define user info here.
          # See: https://github.com/nix-community/home-manager/issues/6036
          users = {
            users.${username} = {
              home = "/Users/${username}";
              name = "${username}";
            };
          };

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.vim
            pkgs.neovim # Text Editor
            pkgs.tree # Produce a depth indented directory listing
            pkgs.tldr # Command cheatsheet
            pkgs.ncdu # Disk usage analyzer
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

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          # Enable Touch ID and Apple Watch with sudo.
          security.pam.services.sudo_local.touchIdAuth = true;

          # macOS system settings
          # TODO: Replace martinlwx with your name.
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
            screencapture.location = "~/Documents/images";
          };
        };
    in
    {
      # TIP: You can refer to the return value of each input here.
      #      e.g., nix-darwin.lib.darwinSystem
      # TIP: Build darwin flake using: $ sudo darwin-rebuild build --flake .#mba
      darwinConfigurations."mba" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          # Ensure that the home-manager will be rebuilt with the nix-darwin generations.
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              # Use the global pkgs that is configured via the system level nixpkgs options.
              useGlobalPkgs = true;
              useUserPackages = true;
              # TODO: Replace martinlwx with your name.
              # WARN: Add home.nix to the git to avoid error like Path '.../home.nix' does not exists.
              #       See: https://discourse.nixos.org/t/flake-based-home-manager-cannot-find-home-nix/18356
              users.martinlwx = import ./home.nix;
            };

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}
