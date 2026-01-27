{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/ghostty.nix
    ./programs/zed.nix
    ./programs/zsh.nix
  ];

  home = {
    username = "mathies";
    homeDirectory = "/Users/mathies";
    stateVersion = "24.05";

    packages = with pkgs; [
      # Language servers
      clang-tools # includes clangd
      lua-language-server
      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
      nodePackages.vscode-langservers-extracted # html, css, json
      pyright
      tinymist # Typst LSP
      typst

      # Formatters
      nodePackages.prettier

      # Dev tools
      pnpm
      direnv
    ];

    sessionVariables = {
      EDITOR = "nvim";
      # Use Apple toolchain for Rust linking on macOS
      CC = "/usr/bin/cc";
      CXX = "/usr/bin/c++";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
    ];
  };

  programs.home-manager.enable = true;

  news.display = "silent";
}
