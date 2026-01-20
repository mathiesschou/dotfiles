{ pkgs, lib, ... }:

{
  # Link Zed configuration (macOS only)
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    "Library/Application Support/Zed/settings.json".source = ../../zed/.config/zed/settings.json;
    "Library/Application Support/Zed/keymap.json".source = ../../zed/.config/zed/keymap.json;
  };
}
