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
        # direnv hook (auto-load Nix environments)
        # Must be loaded before instant prompt to avoid console output warnings
        if command -v direnv &> /dev/null; then
          export DIRENV_LOG_FORMAT=""
          eval "$(direnv hook zsh)"
        fi

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
        alias start='~/.config/tmux/startup.sh'

        # Add npm global bin to PATH
        export PATH="$HOME/.npm-global/bin:$PATH"

        # Docker/Colima configuration
        unset DOCKER_HOST
        export DOCKER_CONTEXT=colima

        # Load Context7 API key from macOS Keychain
        if command -v security &> /dev/null; then
          CONTEXT7_KEY=$(security find-generic-password -a "$USER" -s "context7-api-key" -w 2>/dev/null || echo "")
          if [[ -n "$CONTEXT7_KEY" ]]; then
            export CONTEXT7_API_KEY="$CONTEXT7_KEY"
          else
            echo "WARNING: Context7 API key not found in Keychain"
            echo "Add it with: security add-generic-password -a \"\$USER\" -s \"context7-api-key\" -w \"YOUR_API_KEY\""
          fi
        fi
      ''
    ];
  };

  # Link p10k configuration
  home.file.".p10k.zsh".source = ../../p10k/.p10k.zsh;
}
