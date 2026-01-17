{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/ghostty.nix
    ./programs/zed.nix
  ];

  home = {
    username = "mathies";
    homeDirectory = "/Users/mathies";
    stateVersion = "24.05";

    packages = with pkgs; [
      stow
      zsh-powerlevel10k
      fvm

      # Language servers
      clang-tools # includes clangd
      lua-language-server
      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
      rust-analyzer
      nodePackages.vscode-langservers-extracted # html, css, json
      pyright
      texlab # LaTeX LSP
      texlive.combined.scheme-medium
      tinymist # Typst LSP
      typst
      metals # Scala LSP

      # Formatters
      nodePackages.prettier
    ];

    sessionVariables = {
      EDITOR = "nvim";
      CC = "/usr/bin/cc";
      CXX = "/usr/bin/c++";
      FVM_HOME = "$HOME/.fvm";
      FVM_SKIP_SHELL = "true";
    }; # for rust linking

    # Session path
    sessionPath = [
      "$HOME/.npm-global/bin"
      "$HOME/.fvm/default/bin"
    ];
  };

  programs.home-manager.enable = true;
}
