{ pkgs, lib, ... }:

{
  # Packages to install via pacman (CachyOS/Arch)
  # Run: pacman-install (after home-manager switch)
  home.activation.bootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Install AUR packages if not already installed
    PACKAGES=(
      adguard
      ghostty
      swaybg
      rofi-wayland
      quickshell-git
      noctalia-shell-git
      sddm-sugar-dark
      ttf-jetbrains-mono-nerd
    )

    MISSING=()
    for pkg in "''${PACKAGES[@]}"; do
      if ! pacman -Qi "$pkg" &>/dev/null; then
        MISSING+=("$pkg")
      fi
    done

    if [ ''${#MISSING[@]} -gt 0 ]; then
      echo "==> Installing missing packages: ''${MISSING[*]}"
      yay -S --needed "''${MISSING[@]}"
    fi

    # Configure SDDM if not already done
    if [ ! -f /etc/sddm.conf.d/hide-nix.conf ]; then
      echo "==> Configuring SDDM..."
      sudo mkdir -p /etc/sddm.conf.d
      echo -e "[Users]\nMinimumUid=1000" | sudo tee /etc/sddm.conf.d/hide-nix.conf
      echo -e "[Theme]\nCurrent=sugar-dark" | sudo tee /etc/sddm.conf.d/theme.conf
    fi
  '';

  # Set ghostty as default terminal
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
    };
  };

  home = {
    keyboard = {
      layout = "us,dk";
      options = [ "ctrl:nocaps" "grp:ctrl_space_toggle" ];
    };

    packages = with pkgs; [
      # CLI essentials
      ripgrep
      fd
      fzf
      tree
      htop
      btop
      jq
      unzip
      wget
      curl

      # Dev tools
      gcc
      nodejs_22
      lazygit
      python3

      # Rust
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer

      # Nix tools
      nil
      nixpkgs-fmt
    ];

    sessionVariables = {
      # Linux-specific environment variables
      CC = "gcc";
      CXX = "g++";
    };
  };
}
