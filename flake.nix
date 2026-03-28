{
  description = "mathies schous config for macos.";

  # dependencies pulled in
  inputs = {
    # packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # configuring macOS settings declaratively
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # setting up configurations, and environment variables 
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # homebrew for macOS
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # what is produced from the inputs
  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, rust-overlay }:
    let
      # custom overlay to fix direnv build on darwin (fish tests are broken)
      darwinOverlay = final: prev: {
        direnv = prev.direnv.overrideAttrs (old: {
          doCheck = false;
        });
      };
    in
    {
      # macOS configuration (nix-darwin + home-manager)
      darwinConfigurations."mathies-macos" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          # apply overlay to fix direnv
          { nixpkgs.overlays = [ darwinOverlay rust-overlay.overlays.default ]; }

          # system configuration (default.nix)
          ./hosts/darwin

          # nix-homebrew
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = "mathiesschou";
            };
          }

          # Home Manager module
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.mathiesschou = import ./home/darwin.nix;
            };
          }
        ];
      };

    };
}
