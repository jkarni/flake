{ config, pkgs, lib, ...}: {
  imports = [
    ./default.nix
    ../../modules/services/traefik-cloudflare.nix  #80,443
    ../../modules/services/bangumi.nix
  ];

}