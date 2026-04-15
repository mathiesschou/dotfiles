{ pkgs, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  # system-wide packages
  environment.systemPackages = with pkgs; [
    git
    tree
    ripgrep
    fd
    gcc
    clang
    lazygit
    fzf
    nixd
    nixpkgs-fmt
    typst
    tinymist
    websocat
  ];

  nixpkgs.config.allowUnfree = true; # proprietary software allow
  nixpkgs.config.allowUnsupportedSystem = true; # packages not tested on ARM
  nix.enable = false; # disable managing nix daemon, as it is already installed 

  # set environment variables
  environment.variables = {
    CC = "${pkgs.clang}/bin/clang";
  };

  # system defaults
  system.defaults = {
    NSGlobalDomain = {
      _HIHideMenuBar = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 13;
      "com.apple.trackpad.scaling" = 1.5;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      NewWindowTarget = "Home";
    };

    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
      mru-spaces = false;

      # apps in dock
      persistent-apps = [
        "/Applications/Ghostty.app"
        "/Applications/Safari.app/"
      ];

      persistent-others = [
        "/Users/mathiesschou/Downloads"
      ];
    };
  };

  # allow unstable nix-features  
  nix.settings.experimental-features = "nix-command flakes";

  # use zsh from nix packages as main zsh
  programs.zsh.enable = true;

  # System version
  system.stateVersion = 5;
  system.primaryUser = "mathiesschou";
  networking.computerName = "mathies-macos";
  networking.hostName = "mathies-macos";
  networking.localHostName = "mathies-macos";

  # keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # settings scripts that nixos cannot control 
  system.activationScripts.extraActivation.text = ''
    echo "use input source US and DK"
    /usr/bin/sudo -u mathiesschou /bin/bash -c '
      # Add English (US) input source
      /usr/bin/defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
        "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0</integer><key>KeyboardLayout Name</key><string>U.S.</string></dict>" \
        "<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>9</integer><key>KeyboardLayout Name</key><string>Danish</string></dict>"
    ' || true

    echo "ctrl+space to alternate input sourcess"
    /usr/bin/sudo -u mathiesschou /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>" || true
    /usr/bin/sudo -u mathiesschou /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>786432</integer></array><key>type</key><string>standard</string></dict></dict>" || true

    echo "fn key for emojis"
    /usr/bin/sudo -u mathiesschou /usr/bin/defaults write com.apple.HIToolbox AppleFnUsageType -int 2

    # Apply settings immediately
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    echo "set ghostty as default terminal"
    /usr/bin/sudo -u mathiesschou /usr/bin/env HOME=/Users/mathiesschou /bin/bash ${./scripts/set-default-terminal.sh}

    echo "check if ssh is present, create if not"
    /usr/bin/sudo -u mathiesschou /usr/bin/env HOME=/Users/mathiesschou /bin/bash ${./scripts/setup-ssh.sh}

    # Remove quarantine from f.lux and ensure it's in Login Items
    if [[ -d "/Applications/Flux.app" ]]; then
      echo "Removing quarantine from f.lux"
      /usr/bin/xattr -cr /Applications/Flux.app 2>/dev/null || true

      # Add f.lux to Login Items if not already there
      /usr/bin/sudo -u mathiesschou /usr/bin/osascript -e 'tell application "System Events" to delete login item "Flux"' &>/dev/null || true
      /usr/bin/sudo -u mathiesschou /usr/bin/osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Flux.app", hidden:false}' &>/dev/null || true
      echo "f.lux added to Login Items"
    fi

    echo "setting wallpaper"
    /usr/bin/sudo -u mathiesschou /usr/bin/osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"/Users/mathiesschou/dotfiles/wallpapers/airballons.jpg\""

  '';

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.mathiesschou = {
    name = "mathiesschou";
    home = "/Users/mathiesschou";
  };
}
