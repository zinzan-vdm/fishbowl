{
  description = "devbox";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs_unstable, ... }@inputs:
  let
    system = "x86_64-linux";

    current = import nixpkgs {
      system = system;
      config.allowUnfree = true;
    };

    unstable = import nixpkgs_unstable {
      system = system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          current = current;
          unstable = unstable;
        };

        modules = [
          ./hosts/default/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      basic = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          current = current;
          unstable = unstable;
        };

        modules = [
          ./hosts/basic/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}

