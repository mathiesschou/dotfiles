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
    ];

    taps = [
      "acsandmann/tap"
    ];

    brews = [
      "uv"
      "mas"
      "syncthing"
      "acsandmann/tap/rift"
      "colima"
      "docker"
      "dotnet" # TEMPORARY: needed for C# course — csharp-ls doesn't build on aarch64-darwin via Nix
    ];

    masApps = {
      "Bear" = 1091189122;
      "Flow" = 1423210932;
      "OneDrive" = 823766827;
    };

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
