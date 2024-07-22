{
  # TODO: Update the description of this flake.
  description = "no description provided";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
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
