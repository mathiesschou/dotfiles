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
    username = "mathiesschou";
    homeDirectory = "/Users/mathiesschou";
    stateVersion = "24.05";

    packages = with pkgs; [
      # Nix tools (keep globally for editing dotfiles)
      nil # Nix LSP
      nixpkgs-fmt

      # Essential tools
      direnv

      # Lua
      lua-language-server # Lua LSP

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
      nodePackages.svelte-language-server # Svelte LSP

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

      # Markdown
      marksman # Markdown LSP

      # JSON
      nodePackages.vscode-langservers-extracted # Includes jsonls, html, css, eslint LSPs

      # YAML
      yaml-language-server # YAML LSP

      # Docker
      dockerfile-language-server # Dockerfile LSP
      docker-compose-language-service # docker-compose.yml LSP
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
