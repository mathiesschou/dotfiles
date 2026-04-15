{ ... }:

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

    initContent = ''
      # History configuration
      HISTSIZE=10000
      SAVEHIST=10000
      HISTFILE=~/.zsh_history

      # Aliases
      alias ll='ls -lah'
      alias la='ls -a'
      alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'

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

      # Add Homebrew to PATH
      export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
      export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

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
    '';
  };

}
