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
      "jordanbaird-ice"
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
      "Things 3" = 904280696;
      "Flow" = 1423210932;
      "Numbers" = 409203825;
    };

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
