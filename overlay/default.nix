{ pkgs
, lib
, ...
} @ args: {
  nixpkgs.overlays = [
    (import ./AppleFont)
    (import ./Anime4k)
    (import ./Firefox)
    (import ./ServerStatus)
    (import ./snell)
  ];
}
