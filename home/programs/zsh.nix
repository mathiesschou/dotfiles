{ pkgs
, lib
, ...
}:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$character";
      directory = {
        style = "blue";
        truncation_length = 3;
      };
      git_branch = {
        style = "purple";
        format = "[$branch]($style) ";
      };
      git_status = {
        style = "red";
        format = "[$all_status$ahead_behind]($style) ";
      };
      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };
    };
  };

  programs.zsh = {
    enable = true;

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # direnv hook (auto-load Nix environments)
        if command -v direnv &> /dev/null; then
          export DIRENV_LOG_FORMAT=""
          eval "$(direnv hook zsh)"
        fi
      '')
      ''
        # History configuration
        HISTSIZE=10000
        SAVEHIST=10000
        HISTFILE=~/.zsh_history

        # Aliases
        alias ll='ls -lah'
        alias la='ls -a'

        mkflake() {
          cat > flake.nix <<'EOF'
{
  description = "Dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
          ];
        };
      });
}
EOF

          echo "Created flake.nix"
        }

        # tmux
        alias tn='tmux new-session -s'
        alias tl='tmux list-sessions'
        alias ta='tmux attach-session'

        # Theme switching
        alias light='~/dotfiles/scripts/switch-theme.sh latte'
        alias dark='~/dotfiles/scripts/switch-theme.sh mocha'

        # Save clipboard image to file (workaround for snapshots on Linux)
        alias cpaste='wl-paste > /tmp/clip.png && echo "/tmp/clip.png"'

        # Add Homebrew to PATH
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
        export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

        # Add npm global bin to PATH
        export PATH="$HOME/.npm-global/bin:$PATH"

        # Add Cargo bin to PATH (for rustlings)
        export PATH="$HOME/.cargo/bin:$PATH"

        # Rebuild functions
        unalias dr 2>/dev/null || true
        unalias nr 2>/dev/null || true

        if [[ "$(uname)" == "Darwin" ]]; then
          # macOS: darwin-rebuild
          dr() {
            sudo darwin-rebuild switch --flake ~/dotfiles && exec zsh
          }
        else
          # NixOS: nixos-rebuild (auto-detect hostname)
          dr() {
            local hostname=$(hostname)
            if [[ "$hostname" == "thinkpad-p50" ]]; then
              sudo nixos-rebuild switch --flake ~/dotfiles#thinkpad-p50 --impure && exec zsh
            else
              sudo nixos-rebuild switch --flake ~/dotfiles#nixos-dev --impure && exec zsh
            fi
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
          # DOCKER_CONTEXT removed - switch contexts manually based on project needs
          # Use: docker context use colima (ARM) or docker context use colima-x86 (x86_64)

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

}
