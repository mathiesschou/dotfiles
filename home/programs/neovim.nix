{ config, pkgs, ... }:

{
  # Install neovim directly without wrapper
  home.packages = with pkgs; [
    neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    # Ensure C-based crates can find libiconv
    LIBRARY_PATH = "${pkgs.libiconv}/lib";
  };

  # symlink neovim configuration directory
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
}
