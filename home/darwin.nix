{ config, pkgs, ... }:

{
  # home manager configurations
  imports = [
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/ghostty.nix
    ./programs/zsh.nix
  ];

  home = {
    username = "mathies";
    homeDirectory = "/Users/mathies";
    stateVersion = "24.05";

    packages = with pkgs; [
      # Nix tools (keep globally for editing dotfiles)
      nil # Nix LSP
      nixpkgs-fmt

      # Essential tools
      direnv

      # Python
      python3
      pyright # Python LSP
      black # Python formatter
      isort # Python import sorter

      # Rust
      rustc
      cargo
      rust-analyzer # Rust LSP
      rustfmt # Rust formatter

      # TypeScript/JavaScript
      typescript
      typescript-language-server # TS/JS LSP
      nodePackages.prettier # Code formatter

      # C/C++
      clang-tools # Includes clangd LSP

      # SQL
      sqls # SQL LSP
      sqlite # SQLite database

      # Swift
      swift # Swift compiler
      sourcekit-lsp # Swift LSP

      # C# / .NET
      omnisharp-roslyn # C# LSP (alternative to csharp-ls)
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  programs.home-manager.enable = true;

  news.display = "silent";
}
