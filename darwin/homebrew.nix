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
      "microsoft-word"
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
      "minikube"
      "kubectl"
      "docker"
      "colima"
    ];

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
