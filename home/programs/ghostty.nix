{ ... }:

{
  # Link ghostty configuration directory
  home.file.".config/ghostty" = {
    source = ../../ghostty/.config/ghostty;
    recursive = true;
  };
}
