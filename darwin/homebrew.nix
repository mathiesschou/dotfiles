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
    ];

    taps = [
      "nikitabobko/tap"
      "felixKratz/formulae"
    ];

    brews = [
      "felixkratz/formulae/borders"
      "felixkratz/formulae/sketchybar"
    ];

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
