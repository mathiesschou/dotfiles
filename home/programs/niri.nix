{ config, lib, pkgs, ... }:

{
  xdg.configFile."niri" = {
    source = ../../niri/.config/niri;
    recursive = true;
  };
}
