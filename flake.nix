{
  description = "Cross-platform dotfiles with nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew }:
  let
    # Helper function for home-manager standalone (Linux)
    mkHome = system: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./home ];
    };
  in
  {
    # macOS configuration (nix-darwin + home-manager)
    darwinConfigurations."mathies-macos" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        # nix-darwin configuration
        ./system/darwin

        # nix-homebrew
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "mathies";
          };
        }

        # Home Manager module
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users.mathies = import ./home;
          };
        }
      ];
    };

    # Linux configuration (home-manager standalone)
    # For CachyOS: nix run home-manager -- switch --flake .#mathies-linux
    homeConfigurations."mathies-linux" = mkHome "x86_64-linux";

    # Also support aarch64 Linux (e.g., Raspberry Pi, ARM laptops)
    homeConfigurations."mathies-linux-arm" = mkHome "aarch64-linux";
  };
}
