{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443
    ../../services/kms.nix
    ../../services/change-detection.nix
    ../../services/miniflux-silent.nix # miniflux-silent, miniflux should deploy to different hosts
    ../../services/podman-auto-update.nix
    ../../services/telegraf.nix
  ];
}

