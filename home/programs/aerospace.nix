{ ... }:

{
  # Link aerospace configuration directory
  home.file.".config/aerospace" = {
    source = ../../aerospace/.config/aerospace;
    recursive = true;
  };
}
