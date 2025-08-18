# This configuration is based on the original work by mitchllh (source: https://github.com/mitchellh/nixos-config/blob/main/lib/mksystem.nix)

{
  nixpkgs,
  inputs,
}:

name:

{
  system,
  user,
  darwin ? false,
}:

let
  # Config files for different OS
  machineConfig = ../hosts/${name}.nix;
  userOSConfig = ../users/${if darwin then "darwin" else "nixos"}.nix;
  userHMConfig = ../users/home-manager.nix;

  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager =
    if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc rec {
  inherit system;
  modules = [
    machineConfig
    userOSConfig
    home-manager.home-manager
    {
      # Use the global pkgs that is configured via the system level nixpkgs options.
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHMConfig {
        inputs = inputs;
      };
    }
  ];
}
