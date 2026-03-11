{ config, pkgs, lib, ... }:

{
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    ".config/rift/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/rift/config.toml";
  };
}
