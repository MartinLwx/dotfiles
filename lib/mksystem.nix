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
  wsl ? false,
}:

let
  isWSL = wsl;
  isLinux = !darwin && !isWSL;

  # Config files for different OS
  machineConfig = ../hosts/${name}.nix;
  userOSConfig = ../users/${if darwin then "darwin" else "nixos"}.nix;
  userHMConfig = ../users/home-manager.nix;

  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager =
    if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc {
  # Hint: The submodules can use these special args.
  specialArgs = { inherit inputs ;};
  modules = [
    (if isWSL then inputs.nixos-wsl.nixosModules.wsl else {})
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
