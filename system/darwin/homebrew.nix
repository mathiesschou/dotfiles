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
    ];

    taps = [
    ];

    brews = [
      "direnv"
      "uv"
    ];

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
