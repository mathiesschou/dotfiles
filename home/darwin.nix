{ config, pkgs, ... }:

{
  # home manager configurations
  imports = [
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/ghostty.nix
    ./programs/zsh.nix
  ];

  home = {
    username = "mathiesschou";
    homeDirectory = "/Users/mathiesschou";
    stateVersion = "24.05";

    file.".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";

    packages = with pkgs; [
      swift
      swiftformat
    ];

    sessionVariables = {
      EDITOR = "zed --wait";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  programs.home-manager.enable = true;

  news.display = "silent";
}
