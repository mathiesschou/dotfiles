{ pkgs, lib, ... }:

{
  # Packages to install via pacman (CachyOS/Arch)
  # Run: pacman-install (after home-manager switch)
  home.activation.bootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="/usr/bin:$PATH"

    # Install yay if no AUR helper found
    if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
      echo "==> Installing yay..."
      sudo pacman -S --needed --noconfirm git base-devel
      TEMP_DIR=$(mktemp -d)
      git clone https://aur.archlinux.org/yay.git "$TEMP_DIR/yay"
      (cd "$TEMP_DIR/yay" && makepkg -si --noconfirm)
      rm -rf "$TEMP_DIR"
    fi

    # Prefer yay, fallback to paru
    if command -v yay &>/dev/null; then
      AUR_HELPER="yay"
    else
      AUR_HELPER="paru"
    fi

    PACKAGES=(
      ghostty
      swaybg
      swaylock
      rofi-wayland
      quickshell
      noctalia-shell
      sddm-sugar-dark
      ttf-jetbrains-mono-nerd
      spotify
      python-dbus  # Required for Aarhus University eduroam setup

      # Tauri dependencies
      webkit2gtk-4.1
      libsoup3
      librsvg
    )

    MISSING=()
    for pkg in "''${PACKAGES[@]}"; do
      if ! pacman -Qi "$pkg" &>/dev/null; then
        MISSING+=("$pkg")
      fi
    done

    if [ ''${#MISSING[@]} -gt 0 ]; then
      echo "==> Installing missing packages: ''${MISSING[*]}"
      $AUR_HELPER -S --needed --noconfirm "''${MISSING[@]}"
    fi

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

      # Apps
      anki
    ];

    sessionVariables = {
      # Linux-specific environment variables
      CC = "gcc";
      CXX = "g++";

      # Firefox Wayland + GPU acceleration
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";
    };
  };
}
