{ pkgs, ... }:

{
  home = {
    keyboard = {
      layout = "us,dk";
      options = [ "ctrl:nocaps" "grp:ctrl_space_toggle" ];
    };

    sessionVariables = {
      # Linux-specific environment variables
      CC = "gcc";
      CXX = "g++";
    };
  };
}
