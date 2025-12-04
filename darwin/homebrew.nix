{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "ghostty"
      "zoom"
      "font-meslo-lg-nerd-font"
      "font-ia-writer-quattro"
      "sioyek"
      "microsoft-outlook"
      "microsoft-powerpoint"
      "microsoft-word"
      "nikitabobko/tap/aerospace"
      "spotify"
      "adguard"
      "flux"
      "todoist"
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
      "docker"
      "kubectl"
      "colima"
    ];

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
