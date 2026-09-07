{
  description = "eander0105 nix configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    nixos-hardware,
    flake-utils,
    home-manager,
    solaar,
    ...
  } @inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
      lib = nixpkgs.lib;
    in rec {
      legacyPackages = forAllSystems (system: {
        stable = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        unstable = import inputs.unstable {
          inherit system;
          config.allowUnfree = true;
        };
      });

      nixosModules = import ./modules;
      homeManagerModules = import ./home-manager/modules;

      nixosConfigurations =
        let
          specialArgs = { inherit inputs outputs; };
        in {
          lillagron = lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";
            modules = [
              ./hosts/lillagron
              # nvf.nixosModules.default
              solaar.nixosModules.default
            ];
          };
          # OLD ZOEZI setup
          castor = lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";
            modules = [ ./hosts/castor ];
          };
        };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Add a default package
      defaultPackage = forAllSystems (system: legacyPackages.${system}.alejandra);

      # Add a development shell
      devShell = forAllSystems (system: legacyPackages.${system}.mkShell {
        buildInputs = with legacyPackages.${system}; [ alejandra git ];
      });
    };
}
