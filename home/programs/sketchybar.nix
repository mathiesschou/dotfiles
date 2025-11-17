{ ... }:

{
  # Link sketchybar configuration directory
  home.file.".config/sketchybar" = {
    source = ../../sketchybar/.config/sketchybar;
    recursive = true;
  };
}
