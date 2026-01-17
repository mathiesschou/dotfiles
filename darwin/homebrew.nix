{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "ghostty"
      "rectangle"
      "zoom"
      "anki"
      "font-meslo-lg-nerd-font"
      "font-ia-writer-quattro"
      "sioyek"
      "microsoft-outlook"
      "microsoft-powerpoint"
      "microsoft-onenote"
      "google-chrome"
      "microsoft-word"
      "spotify"
      "adguard"
      "flux-app"
      "font-ia-writer-quattro"
      "font-zed-mono-nerd-font"
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
