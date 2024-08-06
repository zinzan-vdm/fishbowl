{
  # TODO: Update the description of this flake.
  description = "no description provided";

  inputs = {
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, unstable }:
  let
    system = "x86_64-linux";
    pkgs = unstable.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        # TODO: Add your depedencies here.
      ];

      # TODO: Update the PS1 update for terminal with the flake name.
      shellHook = ''
        ps1 'flake: unnamed'
      '';
    };
  };
}
