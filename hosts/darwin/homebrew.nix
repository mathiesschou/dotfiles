{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "ghostty"
      "zoom"
      "anki"
      "sioyek"
      "microsoft-outlook"
      "microsoft-powerpoint"
      "microsoft-onenote"
      "spotify"
      "adguard"
      "flux-app"
      "font-jetbrains-mono-nerd-font"
      "font-commit-mono"
      "zed"
      "zen"
      "discord"
      "jordanbaird-ice"
    ];

    taps = [
      "acsandmann/tap"
    ];

    brews = [
      "uv"
      "mas"
      "syncthing"
      "acsandmann/tap/rift"
    ];

    masApps = {
      "Things 3" = 904280696;
      "Flow" = 1423210932;
      "Numbers" = 409203825;
    };

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
