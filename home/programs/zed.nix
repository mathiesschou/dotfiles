{ ... }:

{
  home.file.".config/zed" = {
    source = ../../zed/.config/zed;
    recursive = true;
  };
}
