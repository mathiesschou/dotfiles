{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "vmware-fusion"
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
