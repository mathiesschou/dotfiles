{ config, pkgs, lib, isLinux, isDarwin, ... }:

{
  imports = [
    ./common.nix
  ]
  ++ lib.optionals isDarwin [ ./darwin.nix ./programs/zsh.nix ./programs/hammerspoon.nix ]
  ++ lib.optionals isLinux [ ./linux.nix ./programs/fish.nix ./programs/niri.nix ];

  home = {
    username = "mathies";
    homeDirectory = if isDarwin then "/Users/mathies" else "/home/mathies";
    stateVersion = "24.05";
  };
}
