{
  description = "Nix development dependencies for crystal";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          fred = pkgs.crystal.buildCrystalPackage {
            pname = "fred";
            version = "0.5.0";
            src = ./.;

            format = "shards";

            shardsFile = ./shards.nix;

            crystalBinaries.fred.src = "src/fred.cr";
          };

          default = self.packages.${system}.fred;
        });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              crystal
              shards
            ];

            nativeBuildInputs = with pkgs; [
              crystal
              shards
            ];
          };
        });
    };
}

