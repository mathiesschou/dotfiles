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
      "zed"
      "zen"
      "discord"
      "drawio"
      "dotnet-sdk" # for job 
      "orbstack"
      "flashspace"
      "rectangle"
      "ffmpeg"
    ];

    taps = [
      "acsandmann/tap"
    ];

    brews = [
      "uv"
      "mas"
      "syncthing"
      "dotnet" # for job
      "postgresql@17"
    ];

    masApps = {
      "Bear" = 1091189122;
      "Flow" = 1423210932;
      "OneDrive" = 823766827;
      "Xcode" = 497799835;
    };

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
