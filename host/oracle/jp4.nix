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

  services.qbittorrent-nox.enable = true;


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

  services.traefik-cloudflare.enable = true;


  virtualisation.podman.defaultNetwork.dnsname.enable =true;

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
        # "--network=miniflux"

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
      # extraOptions = [
      #   "--network=miniflux"
      # ];
    };


  };


  # systemd.services.init-podman-miniflux-network = {
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig.Type = "oneshot";
  #   script =
  #     let
  #       podman = "${pkgs.podman}/bin/podman";
  #     in
  #     ''
  #       # Put a true at the end to prevent getting non-zero return code, which will crash the whole service.
  #       check=$(${podman} network ls | grep "miniflux" || true)
  #       if [ -z "$check" ]; then
  #         ${podman} network create miniflux
  #       else
  #         echo "miniflux already exists"
  #       fi
  #     '';
  # };

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