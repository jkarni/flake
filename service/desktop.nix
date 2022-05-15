{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./gnome.nix
  ];
}
