{ pkgs, lib, ... }@args: {
  nixpkgs.overlays = [
    (import ./AppleFont.nix)
    (import ./Anime4k.nix)
    (import ./Neovim.nix { inherit (args) neovim-nightly; })
    (import ./Firefox.nix { inherit (pkgs) stdenv; })
  ];
}
