{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/ghostty.nix
    ./programs/zed.nix
    # ./programs/aerospace.nix # not used currently
    # ./programs/sketchybar.nix # not used currently
  ];

  home = {
    username = "mathies";
    homeDirectory = "/Users/mathies";
    stateVersion = "24.05";

    packages = with pkgs; [
      stow
      zsh-powerlevel10k

      # Language servers
      clang-tools # includes clangd
      lua-language-server
      nodePackages.typescript-language-server
      rust-analyzer
      nodePackages.vscode-langservers-extracted # html, css, json
      pyright
      texlab # LaTeX LSP
      tinymist # Typst LSP

      # Formatters
      nodePackages.prettier

      # LaTeX
      texlive.combined.scheme-medium

      # Typst
      typst
    ];

    sessionVariables = {
      EDITOR = "nvim";
      CC = "/usr/bin/cc";
      CXX = "/usr/bin/c++";
    }; # for rust linking

    # Session path
    sessionPath = [
      "$HOME/.npm-global/bin"
    ];
  };

  programs.home-manager.enable = true;
}
