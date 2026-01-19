{ config, pkgs, lib, ... }:

{
  imports = [
    ../common.nix
    ./linux-specific.nix
    ../programs/fish.nix
    ../programs/niri.nix
  ];

  home = {
    username = "mathies";
    homeDirectory = "/home/mathies";
    stateVersion = "24.05";
  };
}
