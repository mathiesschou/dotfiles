{ config, pkgs, lib, ... }:

{
  # Link ghostty configuration - different paths for macOS vs Linux
  home.file = lib.mkMerge [
    # macOS: ~/Library/Application Support/com.mitchellh.ghostty/
    (lib.mkIf pkgs.stdenv.isDarwin {
      "Library/Application Support/com.mitchellh.ghostty/config".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/ghostty/config";
      "Library/Application Support/com.mitchellh.ghostty/themes".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/ghostty/themes";
    })
    # Linux: ~/.config/ghostty/
    (lib.mkIf pkgs.stdenv.isLinux {
      ".config/ghostty".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/ghostty";
    })
  ];
}
