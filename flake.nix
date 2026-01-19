{
  description = "macOS dotfiles with nix-darwin and home-manager";

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

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, noctalia }:
  let
    # Overlay to fix direnv build on darwin (fish tests are broken)
    darwinOverlay = final: prev: {
      direnv = prev.direnv.overrideAttrs (old: {
        doCheck = false;
      });
    };
  in
  {
    # NixOS configuration (VM)
    nixosConfigurations."nixos-vm" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./hosts/nixos/configuration.nix

        # Noctalia shell
        noctalia.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users.mathies = import ./home/nixos.nix;
          };
        }
      ];
    };

    # macOS configuration (nix-darwin + home-manager)
    darwinConfigurations."mathies-macos" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        # Apply overlay to fix direnv
        { nixpkgs.overlays = [ darwinOverlay ]; }

        # nix-darwin configuration
        ./system

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

  };
}
