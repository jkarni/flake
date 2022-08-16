{ config, pkgs, lib, ...}: {
  
  # rss to muted tg bot  <-- only for tracking Nixpkgs PR
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
      ${pkgs.cloudflare-dns-sync} miniflux-silent.${config.networking.domain}
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
        "traefik.http.routers.websecure-miniflux.rule=Host(`miniflux-silent.${config.networking.domain}`)"
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

}