{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "ghostty"
      "zoom"
      "anki"
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
      "obsidian"
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
      cleanup = "uninstall"; # Bruger 'uninstall' i stedet for 'zap' - mere stabil
      autoUpdate = true;
      upgrade = true;
    };
  };
}
