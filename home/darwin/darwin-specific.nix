{ pkgs, ... }:

{
  home = {
    sessionVariables = {
      # Use Apple toolchain for Rust linking on macOS
      CC = "/usr/bin/cc";
      CXX = "/usr/bin/c++";
    };
  };
}
