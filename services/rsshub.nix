{ config, pkgs, lib, ... }: {

  virtualisation.oci-containers.containers = {
    "rsshub" = {
      image = "diygod/rsshub";
      extraOptions = [
        "--label"
        "traefik.enable=true"
        "--label"
        "traefik.http.routers.websecure-rsshub.rule=Host(`rss.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-rsshub.entrypoints=websecure"
      ];
    };
  };

  systemd.services.podman-rsshub.preStart = lib.mkAfter ''
    ${pkgs.cloudflare-dns-sync} rss.${config.networking.domain}
  '';
}
