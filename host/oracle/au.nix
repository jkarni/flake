{ config, pkgs, lib, ...}: {
  imports = [
    ./default.nix
    ../../modules/services/server-status/server/default.nix
  ];
}