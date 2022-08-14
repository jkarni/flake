{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;
  #services.status-server.enable = true;

  #services.qbittorrent-nox.enable = true;

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
      ${pkgs.cloudflare-dns-sync} miniflux-db.${config.networking.domain}
    fi
  '';

  services.traefik-cloudflare.enable = true;

  virtualisation.oci-containers.containers = {

    "miniflux" = {
      image = "miniflux/miniflux";
      dependsOn = [ "miniflux-db" ];
      environment = {
        "DATABASE_URL" = "user=miniflux password=12345 dbname=miniflux host=miniflux.mlyxshi.com port=5432 sslmode=disable";
        "RUN_MIGRATIONS" = "1";
        "CREATE_ADMIN" = "1";
        "ADMIN_USERNAME" = "admin";
        "ADMIN_PASSWORD" = "admin";
      };
      extraOptions = [
        "--label"
        "traefik.enable=true"

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
      environment = {
        "POSTGRES_USER" = "miniflux";
        "POSTGRES_PASSWORD" = "12345";
      };
      extraOptions = [
        "--network=host"
      ];
    };


  };

}
