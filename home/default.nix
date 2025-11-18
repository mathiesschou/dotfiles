{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
    ./programs/ghostty.nix
    ./programs/aerospace.nix
    ./programs/sketchybar.nix
  ];

  home = {
    username = "mathies";
    homeDirectory = "/Users/mathies";
    stateVersion = "24.05";

    packages = with pkgs; [
      stow
      zsh-powerlevel10k
      direnv
      nix-direnv
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    # Session path
    sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    # Deploy tmux startup script
    file.".config/tmux/startup.sh" = {
      source = ./scripts/tmux-startup.sh;
      executable = true;
    };
  };

  programs.home-manager.enable = true;
}
