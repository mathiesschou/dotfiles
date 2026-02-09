{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "ghostty"
      "rectangle"
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
      "zed"
      "discord"
    ];

    taps = [
    ];

    brews = [
      "direnv"
      "uv"
      "mas"
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
