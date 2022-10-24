{ config, pkgs, lib, ... }: {

  virtualisation.oci-containers.containers = {
    "azure-web" = {
      image = "1injex/azure-manager";
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.azure.rule=Host(`azure.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.azure.entrypoints=websecure"
        "--label"
        "traefik.http.routers.azure.middlewares=auth@file"

        "--label"
        "io.containers.autoupdate=registry"
      ];
    };
  };

  systemd.services.podman-kms-server.environment.PODMAN_SYSTEMD_UNIT = "%n";

  system.activationScripts.cloudflare-dns-sync-azure = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} azure.${config.networking.domain}
    '';
  };

}
