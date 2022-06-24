{ lib, pkgs, neovim-nightly, ... }: {
  nixpkgs.overlays = [
    (import ./AppleFont.nix)
    (import ./Anime4k.nix)
    (import ./Neovim.nix { inherit neovim-nightly; })
    (import ./Firefox.nix { inherit (pkgs) stdenv; })

    (import ./wlroots.nix {inherit (pkgs) fetchFromGitLab;})
  ];
}
