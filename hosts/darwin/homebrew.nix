{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "ghostty"
      "zoom"
      "anki"
      "spotify"
      "adguard"
      "flux-app"
      "font-commit-mono"
      "discord"
      "drawio"
      "dotnet-sdk" # for job
      "orbstack"
      "flashspace"
      "rectangle"
      "mactex-no-gui" # for manim LaTeX rendering
    ];

    taps = [
    ];

    brews = [
      "uv"
      "mas"
      "syncthing"
      "dotnet" # for job
      "postgresql@17"
      "ffmpeg"
      "cairo"
      "pkg-config"
    ];

    masApps = {
      "Bear" = 1091189122;
      "Flow" = 1423210932;
      # "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Xcode" = 497799835;
    };

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
