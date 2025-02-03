{
  # TODO: Update the description of this flake.
  description = "no description provided";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs_unstable }:
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
    devShells.${system} = {
      default = current.mkShell {
        buildInputs = [
          # TODO: Add your dependencies here.
        ];

        # TODO: Update the PS1 update for terminal with the flake name.
        shellHook = ''
          ps1 'flake: unnamed' 2>/dev/null
        '';
      };
    };
  };
}
