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

        # Create dev flake template
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

        # tmux aliases
        alias tn='tmux new-session -s'
        alias tl='tmux list-sessions'
        alias ta='tmux attach-session'

        # Theme switching
        alias light='~/dotfiles/hosts/darwin/scripts/switch-theme.sh latte'
        alias dark='~/dotfiles/hosts/darwin/scripts/switch-theme.sh mocha'

        # Add Homebrew to PATH
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
        export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

        # Add npm global bin to PATH
        export PATH="$HOME/.npm-global/bin:$PATH"

        # Add Cargo bin to PATH
        export PATH="$HOME/.cargo/bin:$PATH"

        # Rebuild darwin system
        dr() {
          sudo darwin-rebuild switch --flake ~/dotfiles && exec zsh
        }

        # Prefer Apple toolchain for builds
        if command -v xcrun &> /dev/null; then
          export CC="$(xcrun --find clang)"
          export SDKROOT="$(xcrun --show-sdk-path)"
          export LIBRARY_PATH="$SDKROOT/usr/lib"
        fi

        # Load Context7 API key from macOS Keychain
        if command -v security &> /dev/null; then
          CONTEXT7_KEY=$(security find-generic-password -a "$USER" -s "context7-api-key" -w 2>/dev/null || echo "")
          if [[ -n "$CONTEXT7_KEY" ]]; then
            export CONTEXT7_API_KEY="$CONTEXT7_KEY"
          fi
        fi
      ''
    ];
  };

}
