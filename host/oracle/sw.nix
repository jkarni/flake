{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443
    ../../services/bangumi.nix
    ../../services/podman-auto-update.nix
  ];


}
