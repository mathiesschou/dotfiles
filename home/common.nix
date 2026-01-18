{ pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/ghostty.nix
  ];

  home = {
    packages = with pkgs; [
      zsh-powerlevel10k

      # Language servers
      clang-tools # includes clangd
      lua-language-server
      nodePackages.typescript-language-server
      nodePackages.svelte-language-server
      nodePackages.vscode-langservers-extracted # html, css, json
      pyright
      texlab # LaTeX LSP
      texlive.combined.scheme-medium
      tinymist # Typst LSP
      typst

      # Formatters
      nodePackages.prettier
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
    ];
  };

  programs.home-manager.enable = true;
}
