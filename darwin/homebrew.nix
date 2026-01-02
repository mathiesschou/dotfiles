{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "ghostty"
      "rectangle"
      "readdle-spark"
      "zoom"
      "anki"
      "font-meslo-lg-nerd-font"
      "font-ia-writer-quattro"
      "sioyek"
      "microsoft-outlook"
      "microsoft-powerpoint"
      "google-chrome"
      "microsoft-word"
      "nikitabobko/tap/aerospace"
      "spotify"
      "adguard"
      "flux-app"
      "todoist-app"
      "obsidian"
      "zed"
      "font-ia-writer-quattro"
      "font-zed-mono-nerd-font"
      "flutter"
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
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
