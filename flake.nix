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

};

  # what is produced from the inputs
  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew }:
    {
      # macOS configuration (nix-darwin + home-manager)
      darwinConfigurations."mathies-macos" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [

          # system configuration (default.nix)
          ./hosts/darwin

          # nix-homebrew
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
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
