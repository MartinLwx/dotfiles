{
  description = "MartinLwx nix-darwin system flake";

  # The dependencies of this flake.nix.
  # Syntax: github:owner/name/reference
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      # HINT: import ./lib/mksystem.nix returns a function
      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs inputs;
      };
    in
    {
      nixosConfigurations.wsl = mkSystem "wsl" {
        system = "x86_64-linux";
        user = "martinlwx";
        wsl = true;
      };
      # TIP: You can refer to the return value of each input here.
      #      e.g., nix-darwin.lib.darwinSystem
      # TIP: Build darwin flake using: $ sudo darwin-rebuild build --flake .#mba
      darwinConfigurations."mba" = mkSystem "mba" {
        system = "aarch64-darwin";
        user = "martinlwx";
        darwin = true;
      };
    };
}
