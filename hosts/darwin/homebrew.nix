{ ... }:

{
  homebrew = {
    enable = true;

    casks = [
      "ghostty"
      "zed"	
      "zoom"
      "anki"
      "spotify"
      "adguard"
      "flux-app"
      "font-commit-mono"
      "discord"
      "drawio"
      "dotnet-sdk"
      "orbstack"
      "flashspace"
      "rectangle"
      "obsidian" # temp untill summer.
    ];

    taps = [
    ];

    brews = [
      "uv" # venv
      "mas"
      "dotnet"
      "postgresql@17"
      "neovim"
    ];

    masApps = {
      "Bear" = 1091189122;
      "Flow" = 1423210932;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Things" = 904280696;
      "Xcode" = 497799835;
    };

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
