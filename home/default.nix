{ config, pkgs, lib, isLinux, isDarwin, ... }:

{
  imports = [
    ./common.nix
  ]
  ++ (if isDarwin then [ ./darwin.nix ./programs/zsh.nix ] else [ ./linux.nix ./programs/fish.nix ./programs/niri.nix ]);

  home = {
    username = "mathies";
    homeDirectory = if isDarwin then "/Users/mathies" else "/home/mathies";
    stateVersion = "24.05";
  };
}
