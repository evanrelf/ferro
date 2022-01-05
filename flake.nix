{
  description = "ferro";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        packages.ferro =
          pkgs.haskellPackages.callCabal2nix "ferro" ./. { };

        defaultPackage =
          packages.ferro;

        devShell =
          packages.ferro.env.overrideAttrs (prev: {
            buildInputs = (prev.buildInputs or [ ]) ++ [ pkgs.cabal-install ];
          });
      }
    );
}
