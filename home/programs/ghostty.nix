{ pkgs, lib, ... }:

{
  # Link ghostty configuration - different paths for macOS vs Linux
  home.file = lib.mkMerge [
    # macOS: ~/Library/Application Support/com.mitchellh.ghostty/
    (lib.mkIf pkgs.stdenv.isDarwin {
      "Library/Application Support/com.mitchellh.ghostty/config".source = ../../ghostty/.config/ghostty/config;
      "Library/Application Support/com.mitchellh.ghostty/themes" = {
        source = ../../ghostty/.config/ghostty/themes;
        recursive = true;
      };
    })
    # Linux: ~/.config/ghostty/
    (lib.mkIf pkgs.stdenv.isLinux {
      ".config/ghostty" = {
        source = ../../ghostty/.config/ghostty;
        recursive = true;
      };
    })
  ];
}
