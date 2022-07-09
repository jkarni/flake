{
  pkgs,
  lib,
  ...
} @ args: {
  nixpkgs.overlays = [
    (import ./AppleFont)
    (import ./Anime4k)
    (import ./Nvim {inherit (args) neovim-nightly;})
    (import ./Mpv {inherit (args) mpv-nightly;})
    (import ./Firefox)
  ];
}
