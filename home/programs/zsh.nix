{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Enable Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
        # Load p10k configuration if it exists
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # History configuration
        HISTSIZE=10000
        SAVEHIST=10000
        HISTFILE=~/.zsh_history

        # Nix-darwin function (rebuilds and reloads shell)
        unalias dr 2>/dev/null || true
        dr() {
          sudo darwin-rebuild switch --flake ~/dotfiles && exec zsh
        }

        # Aliases
        alias ll='ls -lah'
        alias la='ls -a'

        # Add npm global bin to PATH
        export PATH="$HOME/.npm-global/bin:$PATH"

        # direnv hook (auto-load Nix environments)
        # Installed via Homebrew to avoid fish dependency issue
        if command -v direnv &> /dev/null; then
          eval "$(direnv hook zsh)"
        fi
      ''
    ];
  };

  # Link p10k configuration
  home.file.".p10k.zsh".source = ../../p10k/.p10k.zsh;
}
