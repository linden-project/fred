{
  description = "Nix development dependencies for crystal";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-22.11;
    flake-utils.url = github:numtide/flake-utils;
    crystal-flake.url = github:manveru/crystal-flake;
  };

  outputs = inputs:
    let
      utils = inputs.flake-utils.lib;
    in
    utils.eachSystem
      [
        "x86_64-linux"
      ]
      (system:
        let
          nixpkgs = import inputs.nixpkgs {
            inherit system;
          };

          crystalflake-pkg = inputs.crystal-flake.packages.${system};
        in
        {

          devShells.default = nixpkgs.pkgs.mkShell {
            buildInputs = with nixpkgs.pkgs; [
              crystal
              shards
            ];

            nativeBuildInputs = with nixpkgs.pkgs; [
              crystal
              shards
            ];
          };
        });
}

