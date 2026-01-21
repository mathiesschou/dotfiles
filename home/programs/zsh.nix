{
  config,
  pkgs,
  lib,
  ...
}:

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
        # Load p10k configuration
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # History configuration
        HISTSIZE=10000
        SAVEHIST=10000
        HISTFILE=~/.zsh_history

        # Aliases
        alias ll='ls -lah'
        alias la='ls -a'

        # Add npm global bin to PATH
        export PATH="$HOME/.npm-global/bin:$PATH"

        # Rebuild functions
        unalias dr 2>/dev/null || true
        unalias nr 2>/dev/null || true

        if [[ "$(uname)" == "Darwin" ]]; then
          # macOS: darwin-rebuild
          dr() {
            sudo darwin-rebuild switch --flake ~/dotfiles && exec zsh
          }
        else
          # NixOS: nixos-rebuild
          dr() {
            sudo nixos-rebuild switch --flake ~/dotfiles#nixos --impure && exec zsh
          }
        fi

        # macOS-specific configuration
        if [[ "$(uname)" == "Darwin" ]]; then
          # Prefer Apple toolchain for builds
          if command -v xcrun &> /dev/null; then
            export CC="$(xcrun --find clang)"
            export SDKROOT="$(xcrun --show-sdk-path)"
            export LIBRARY_PATH="$SDKROOT/usr/lib"
          fi

          # Docker/Colima configuration
          unset DOCKER_HOST
          export DOCKER_CONTEXT=colima

          # Load Context7 API key from macOS Keychain
          if command -v security &> /dev/null; then
            CONTEXT7_KEY=$(security find-generic-password -a "$USER" -s "context7-api-key" -w 2>/dev/null || echo "")
            if [[ -n "$CONTEXT7_KEY" ]]; then
              export CONTEXT7_API_KEY="$CONTEXT7_KEY"
            fi
          fi
        fi
      ''
    ];
  };

  # Link p10k configuration
  home.file.".p10k.zsh".source = ../../p10k/.p10k.zsh;
}
