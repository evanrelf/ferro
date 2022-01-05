pkgsFinal: pkgsPrev:

let
  calibreDarwin =
    # TODO: Finish packaging `calibre` for Darwin.
    #
    # Here's how Nixpkgs does it for Linux:
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/calibre/default.nix
    #
    # Here's how Homebrew does it with their cask:
    # https://github.com/Homebrew/homebrew-cask/blob/master/Casks/calibre.rb
    #
    # The upstream build process for Darwin is kinda insane: it uses a some kind
    # of home-grown build system, written in Python, to build everything on Linux
    # in a QEMU VM (for the Darwin build!?). So I'm just gonna download the
    # pre-built disk image from the website.
    #
    # Here's examples of other Mac apps packaged from disk images:
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/keeweb/default.nix
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/instant-messengers/slack/default.nix
    pkgsPrev.stdenv.mkDerivation rec {
      inherit (pkgsPrev.cross.x86_64-linux.calibre) pname version;

      src = pkgsPrev.fetchurl {
        url = "https://download.calibre-ebook.com/${version}/calibre-${version}.dmg";
        sha256 = "sha256-oXZGY4xcg6pAf5NJo9p5gXqYYtByej3TdBszT7Dp1jE=";
      };

      sourceRoot = ".";

      # TODO: Extract the `.app` bundle from the disk image.
      #
      # `undmg` no longer works because of APFS (either because the DMG is using
      # an APFS filesystem, or macOS is trying to mount the DMG using an APFS
      # filesystem).
      #
      # Here's discussion about this on the `undmg` issue tracker:
      # https://github.com/matthewbauer/undmg/issues/4
      #
      # Here's how Homebrew manages this, using Apple's `hdiutil` tool:
      # https://github.com/Homebrew/brew/blob/master/Library/Homebrew/unpack_strategy/dmg.rb#L173-L237
      nativeBuildInputs = [ pkgsFinal.undmg ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/Applications
        cp -r calibre.app $out/Applications/calibre.app

        mkdir -p $out/bin
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/calibre
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/calibre-complete
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/calibre-customize
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/calibre-debug
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/calibre-parallel
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/calibre-server
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/calibre-smtp
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/calibredb
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/ebook-convert
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/ebook-device
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/ebook-edit
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/ebook-meta
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/ebook-polish
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/ebook-viewer
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/fetch-ebook-metadata
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/lrf2lrs
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/lrfviewer
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/lrs2lrf
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/markdown-calibre
        ln -s $out{/Applications/calibre.app/Contents/MacOS,/bin}/web2disk

        runHook postInstall
      '';

      meta = pkgsPrev.cross.x86_64-linux.calibre.meta // {
        platforms = pkgsPrev.lib.platforms.darwin;
      };
    };

in
{
  calibre =
    if pkgsPrev.stdenv.isLinux then
      pkgsPrev.calibre
    else if pkgsPrev.stdenv.isDarwin then
      calibreDarwin
    else
      builtins.throw "Building calibre is not supported on this system";
}
