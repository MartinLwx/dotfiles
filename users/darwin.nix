{ inputs, pkgs, ... }:
{
  users.users.martinlwx = {
    home = "/Users/martinlwx/";
    shell = pkgs.zsh;
  };
}
