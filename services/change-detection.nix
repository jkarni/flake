{ config, pkgs, lib, ... }: {

  virtualisation.oci-containers.containers = {
    "playwright-chrome" = {
      image = "browserless/chrome";
      extraOptions = [
        "--label"
        "io.containers.autoupdate=registry"
      ];
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

        "--label"
        "io.containers.autoupdate=registry"
      ];
    };
  };

  systemd.services.podman-change-detection-io.serviceConfig.StateDirectory = "changeio";

  systemd.services.podman-playwright-chrome.environment.PODMAN_SYSTEMD_UNIT = "%n";
  systemd.services.podman-change-detection-io.environment.PODMAN_SYSTEMD_UNIT = "%n";

  system.activationScripts.cloudflare-dns-sync-change-detection-io = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} change.${config.networking.domain}
    '';
  };

}
