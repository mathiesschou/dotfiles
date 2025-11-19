{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "ghostty"
      "zoom"
      "font-meslo-lg-nerd-font"
      "sioyek"
      "microsoft-outlook"
      "microsoft-powerpoint"
      "nikitabobko/tap/aerospace"
      "spotify"
      "adguard"
      "flux"
    ];

    taps = [
      "nikitabobko/tap"
      "felixKratz/formulae"
    ];

    brews = [
      "felixkratz/formulae/borders"
      "felixkratz/formulae/sketchybar"
      "direnv"
      "uv"
    ];

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
