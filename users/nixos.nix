{ pkgs, inputs, ... }:

{
  programs.zsh.enable = true;
  users.users.martinlwx = {
    shell = pkgs.zsh;
  };
}
