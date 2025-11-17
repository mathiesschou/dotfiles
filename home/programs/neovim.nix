{ ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Link neovim configuration directory
  # This allows you to keep your existing nvim config structure
  home.file.".config/nvim" = {
    source = ../../nvim/.config/nvim;
    recursive = true;
  };
}
