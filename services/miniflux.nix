{ config, pkgs, lib, ... }: {

  # rss to unmuted tg bot  <-- important updates and news
  sops.secrets.restic-env = { };
  sops.secrets.restic-password = { };

  sops.secrets.miniflux-env = { };
  sops.secrets.miniflux-db-env = { };

  # restic restore backup /var/lib/miniflux-db

  virtualisation.oci-containers.containers = {

    "miniflux" = {
      image = "miniflux/miniflux";
      dependsOn = [ "miniflux-db" ];
      environmentFiles = [ config.sops.secrets.miniflux-env.path ];
      environment = {
        CREATE_ADMIN = "1";
        RUN_MIGRATIONS = "1";
        POLLING_FREQUENCY = "10";
        POLLING_PARSING_ERROR_LIMIT = "0";
        METRICS_COLLECTOR = "1";
        METRICS_ALLOWED_NETWORKS = "0.0.0.0/0";
      };
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.miniflux.rule=Host(`miniflux.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.miniflux.service=miniflux"
        "--label"
        "traefik.http.routers.miniflux.entrypoints=websecure"

        "--label"
        "traefik.http.routers.miniflux-metric.rule=Host(`miniflux.${config.networking.domain}`) && Path(`/metrics`)"
        "--label"
        "traefik.http.routers.miniflux-metric.service=miniflux-metric"
        "--label"
        "traefik.http.routers.miniflux-metric.entrypoints=websecure"

        "--label"
        "traefik.http.services.miniflux.loadbalancer.server.port=8080"
        "--label"
        "traefik.http.services.miniflux-metric.loadbalancer.server.port=8080"

        "--label"
        "io.containers.autoupdate=registry"
      ];
    };

    "miniflux-db" = {
      image = "postgres";
      volumes = [
        "/var/lib/miniflux-db:/var/lib/postgresql/data"
      ];
      environmentFiles = [ config.sops.secrets.miniflux-db-env.path ];
    };

  };


  systemd.services.podman-miniflux.environment.PODMAN_SYSTEMD_UNIT = "%n";

  system.activationScripts.cloudflare-dns-sync-miniflux = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync}/bin/cloudflare-dns-sync miniflux.${config.networking.domain}
    '';
  };

  services.restic.backups."miniflux-db-backup" = {
    environmentFile = config.sops.secrets.restic-env.path;
    passwordFile = config.sops.secrets.restic-password.path;
    paths = [ "/var/lib/miniflux-db" ];
    timerConfig.OnCalendar = "04:00";
    pruneOpts = [ "--keep-last 2" ];
  };

}
