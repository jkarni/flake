{ config, pkgs, lib, ... }: {

  virtualisation.oci-containers.containers = {
    "playwright-chrome" = {
      image = "browserless/chrome";
    };

    "change-detection-io" = {
      image = "dgtlmoon/changedetection.io";
      volumes = [ "/var/lib/changeio:/datastore" ];
      dependsOn = [ "playwright-chrome" ];
      environment = {
        PLAYWRIGHT_DRIVER_URL = "ws://playwright-chrome:3000/";
      };
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.change.rule=Host(`change.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.change.entrypoints=websecure"
        "--label"
        "traefik.http.routers.change.middlewares=auth@file"
      ];
    };

  };

  systemd.services.podman-change-detection-io.preStart = lib.mkAfter ''
    mkdir -p /var/lib/changeio
    ${pkgs.cloudflare-dns-sync} change.${config.networking.domain}
  '';
}
