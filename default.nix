# https://input-output-hk.github.io/haskell.nix/tutorials/getting-started/
{ compiler ? "ghc8107",
  ghcVersion ? "8.10.7",
  withCoverage ? false,

}:
  let
    sources = import ./nix/sources.nix {};
    haskellNix = import sources.haskellNix {};
    pkgs = import
      haskellNix.sources.nixpkgs-unstable
      haskellNix.nixpkgsArgs;

  in
    pkgs.haskell-nix.project {
      modules = [
        {
          packages.old-time.components.library.preConfigure = ''
            ${pkgs.autoconf}/bin/autoreconf -i
          '';
        }
      ];

      src = pkgs.haskell-nix.haskellLib.cleanGit {

        name = "old-time";
        src = ./.;
      };
      compiler-nix-name = compiler;
    }
