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

    # menu bar for nixOS
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # what is produced from the inputs
  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, noctalia }:
    let
      # custom overlay to fix direnv build on darwin (fish tests are broken)
      darwinOverlay = final: prev: {
        direnv = prev.direnv.overrideAttrs (old: {
          doCheck = false;
        });
      };
    in
    {
      # NixOS configuration (ThinkPad P50)
      nixosConfigurations."thinkpad-p50" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit noctalia; };
        modules = [
          ./hosts/thinkpad-p50/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { hostName = "thinkpad-p50"; };
              users.mathies = import ./home/nixos.nix;
            };
          }
        ];
      };

      # NixOS configuration (VM)
      nixosConfigurations."nixos-dev" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit noctalia; };
        modules = [
          ./hosts/nixos/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { hostName = "nixos-dev"; };
              users.mathies = import ./home/nixos.nix;
            };
          }
        ];
      };

      # macOS configuration (nix-darwin + home-manager)
      darwinConfigurations."mathies-macos" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          # apply overlay to fix direnv
          { nixpkgs.overlays = [ darwinOverlay ]; }

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
