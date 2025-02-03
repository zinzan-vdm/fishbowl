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
      headless = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          current = current;
          unstable = unstable;
        };

        modules = [
          ./hosts/headless/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      headed = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          current = current;
          unstable = unstable;
        };

        modules = [
          ./hosts/headed/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      gaming = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          current = current;
          unstable = unstable;
        };

        modules = [
          ./hosts/gaming/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}

