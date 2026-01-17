{ pkgs, ... }:

{
  home = {
    sessionVariables = {
      # Linux-specific environment variables
      CC = "gcc";
      CXX = "g++";
    };
  };
}
