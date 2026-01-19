{ config, pkgs, lib, ... }:

{
  imports = [
    ../common.nix
    ./darwin-specific.nix
    ../programs/zsh.nix
  ];

  home = {
    username = "mathies";
    homeDirectory = "/Users/mathies";
    stateVersion = "24.05";
  };
}
