{ pkgs, lib, config, ... }: {

  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443
    ../../services/rsshub.nix
    ../../services/miniflux.nix
    ../../services/vaultwarden.nix
    ../../services/podman-auto-update.nix
    ../../services/telegraf.nix
  ];

}
