{ pkgs, lib, ... }@args: {
  nixpkgs.overlays = [
    (import ./AppleFont.nix)
    (import ./Anime4k.nix)
    (import ./Neovim.nix { inherit (args) neovim-nightly; })


    (final: prev: {
      firefox-nightly-bin-darwin = prev.callPackage ../pkgs/darwin/firefox { };
    })

  ];
}
