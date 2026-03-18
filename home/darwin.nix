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

    # Theme files are now managed by scripts/switch-theme.sh
    # file = {
    #   ".config/tmux/theme.conf".source = ../config/tmux/theme-light.conf;
    #   ".config/theme-mode".text = "light\n";
    # };

    packages = with pkgs; [
      # Nix tools (keep globally for editing dotfiles)
      nil # Nix LSP
      nixpkgs-fmt

      # Essential tools
      direnv
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
