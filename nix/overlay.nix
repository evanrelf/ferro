pkgsFinal: pkgsPrev:

let
  inherit (pkgsPrev) haskell-overlay;

in
haskell-overlay.mkOverlay
{
  extensions = [
    (haskell-overlay.sources (haskellPackagesFinal: haskellPackagesPrev: {
      ferro = ../.;
    }))

    (haskell-overlay.overrideCabal (haskellPackagesFinal: haskellPackagesPrev: {
      readability = prev: {
        broken = false;
        jailbreak = true;
      };

      req-conduit = prev: {
        broken = false;
      };
    }))
  ];
}
  pkgsFinal
  pkgsPrev
