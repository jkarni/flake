{ config, pkgs, lib, ...}: {

  sops.secrets.restic-password = { };
  sops.secrets.rclone-config = { };

  sops.secrets.miniflux-env = { };
  sops.secrets.miniflux-db-env = { };

  system.activationScripts.makeMinifluxDBDir = lib.stringAfter [ "var" ] ''
    [ ! -d /var/lib/miniflux-db ] && mkdir -p /var/lib/miniflux-db
  '';

  system.activationScripts.SyncMinifluxDNS = lib.stringAfter [ "var" ] ''
    RED='\033[0;31m'
    NOCOLOR='\033[0m'
    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} miniflux.${config.networking.domain}
    fi
  '';

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



  services.restic.backups."miniflux-db-backup" = {
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [
      "/var/lib/miniflux-db"
    ];
    repository = "rclone:r2:backup";
    timerConfig.OnCalendar = "04:00";
    pruneOpts = [ "--keep-last 2" ];
  };

}