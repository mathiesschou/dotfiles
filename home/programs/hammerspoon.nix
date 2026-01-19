{ ... }:

{
  # Link hammerspoon configuration directory
  home.file.".hammerspoon/init.lua" = {
    source = ../../hammerspoon/.hammerspoon/init.lua;
  };
}
