{ config, pkgs, lib, ... }: {

  virtualisation.oci-containers.containers = {
    "kms-server" = {
      image = "mikolatero/vlmcsd";
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.kms.rule=Host(`kms.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.kms.entrypoints=web"
      ];
    };
  };

  systemd.services.podman-kms-server.preStart = lib.mkAfter ''
    ${pkgs.cloudflare-dns-sync} kms.${config.networking.domain}
  '';
}
