{
  description = "ferro";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    haskell-overlay.url = "github:evanrelf/haskell-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          inputs.haskell-overlay.overlay
          (import ./nix/overlay.nix)
        ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
        packages.ferro = pkgs.haskellPackages.ferro;
        defaultPackage = pkgs.haskellPackages.ferro;
        devShell = pkgs.haskellPackages.ferro.env;
      }
    );
}
