{ config, pkgs, lib, ... }: {

  # rss to unmuted tg bot  <-- important updates and news
  sops.secrets.restic-password = { };
  sops.secrets.rclone-config = { };

  sops.secrets.miniflux-env = { };
  sops.secrets.miniflux-db-env = { };

  # restic restore backup /var/lib/miniflux-db

  virtualisation.oci-containers.containers = {

    "miniflux" = {
      image = "miniflux/miniflux";
      dependsOn = [ "miniflux-db" ];
      environmentFiles = [ config.sops.secrets.miniflux-env.path ];
      environment = {
        INVIDIOUS_INSTANCE = "youtube.${config.networking.domain}";
        CREATE_ADMIN = "1";
        RUN_MIGRATIONS = "1";
      };
      extraOptions = [

        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.miniflux.rule=Host(`miniflux.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.miniflux.entrypoints=web"
        "--label"
        "traefik.http.routers.miniflux.middlewares=web-redirect@file"

        "--label"
        "traefik.http.routers.websecure-miniflux.rule=Host(`miniflux.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-miniflux.entrypoints=websecure"
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

  systemd.services.podman-miniflux.preStart = lib.mkAfter ''
    ${pkgs.cloudflare-dns-sync} miniflux.${config.networking.domain}
  '';

  services.restic.backups."miniflux-db-backup" = {
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [ "/var/lib/miniflux-db" ];
    repository = "rclone:r2:backup";
    timerConfig.OnCalendar = "04:00";
    pruneOpts = [ "--keep-last 2" ];
  };

}
