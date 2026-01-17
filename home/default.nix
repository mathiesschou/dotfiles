{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ./common.nix
  ]
  ++ (if isDarwin then [ ./darwin.nix ./programs/zsh.nix ] else [ ./linux.nix ./programs/fish.nix ]);

  home = {
    username = "mathies";
    homeDirectory = if isDarwin then "/Users/mathies" else "/home/mathies";
    stateVersion = "24.05";
  };
}
