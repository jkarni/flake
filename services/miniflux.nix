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
        POLLING_FREQUENCY = "30";
      };
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.websecure-miniflux.rule=Host(`miniflux.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-miniflux.entrypoints=websecure"

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
      ${pkgs.cloudflare-dns-sync} miniflux.${config.networking.domain}
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
