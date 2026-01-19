{ pkgs, ... }:

{
  # Install neovim directly without wrapper
  home.packages = with pkgs; [
    neovim
    neovim-qt  # gvim alternative
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Link neovim configuration directory
  home.file.".config/nvim" = {
    source = ../../nvim/.config/nvim;
    recursive = true;
    force = true;
  };
}
