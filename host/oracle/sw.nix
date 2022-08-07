{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;


  system.activationScripts.SyncMediaDNS = lib.stringAfter [ "var" ] ''
    RED='\033[0;31m'
    NOCOLOR='\033[0m'

    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} jackett.mlyxshi.com
      ${pkgs.cloudflare-dns-sync} sonarr.mlyxshi.com
      ${pkgs.cloudflare-dns-sync} qb.media.mlyxshi.com
      ${pkgs.cloudflare-dns-sync} jellyfin.mlyxshi.com
    fi
  '';

  # system.activationScripts.makeDownloadDir = pkgs.lib.stringAfter [ "var" ] ''
  #   [ ! -d /download/jackett/config ] && mkdir -p /download/jackett/config
  #   [ ! -d /download/qbittorrent/config ] && mkdir -p /download/qbittorrent/config
  #   [ ! -d /download/jellyfin/config ] && mkdir -p /download/jellyfin/config
  #   [ ! -d /download/sonarr/config ] && mkdir -p /download/sonarr/config
  #   [ ! -d /download/sonarr/downloads ] && mkdir -p /download/sonarr/downloads
  #   [ ! -d /download/sonarr/media/anime ] && mkdir -p /download/sonarr/media/anime
  # '';

  # restic restore backup to create basic configuration tree directory

  services.traefik-cloudflare.enable = true;

  # services.traefik.dynamicConfigOptions = {
  #   http.routers = {
  #     jackett.rule = "Host(`jackett.mlyxshi.com`)";
  #     jackett.service = "jackett";

  #     sonarr.rule = "Host(`sonarr.mlyxshi.com`)";
  #     sonarr.service = "sonarr";

  #     qb-media.rule = "Host(`qb.media.mlyxshi.com`)";
  #     qb-media.service = "qb-media";

  #     jellyfin.rule = "Host(`jellyfin.mlyxshi.com`)";
  #     jellyfin.service = "jellyfin";
  #   };

  #   http.services = {
  #     jackett.loadBalancer.servers = [{ url = "http://localhost:9117"; }];
  #     sonarr.loadBalancer.servers = [{ url = "http://localhost:8989"; }];
  #     qb-media.loadBalancer.servers = [{ url = "http://localhost:8081"; }];
  #     jellyfin.loadBalancer.servers = [{ url = "http://localhost:8096"; }];
  #   };
  # };

  # https://reorx.com/blog/track-and-download-shows-automatically-with-sonarr


  virtualisation.oci-containers.containers = {
    whoami = {
      image = "traefik/whoami";
      extraOptions = [
        "--label=traefik.enable=true"
        "--label=traefik.http.routers.whoami.rule=Host(`whoami.mlyxshi.com`)"
      ];
    };

    "jackett" = {
      image = "linuxserver/jackett";
      # ports = [ "127.0.0.1::9117" ];
      volumes = [
        "/download/jackett/config:/config"
      ];
      # extraOptions = [
      #   "--network=host"
      # ];
      extraOptions = [
        "--label=traefik.enable=true"
        "--label=traefik.http.routers.jackett.rule=Host(`jackett.mlyxshi.com`)"
      ];
    };

    "sonarr" = {
      image = "linuxserver/sonarr";
      volumes = [
        "/download/sonarr:/data"
        "/download/sonarr/config:/config"
      ];
      environment = {
        "PUID" = "0";
        "PGID" = "0";
      };
      extraOptions = [
        "--network=host"
      ];
    };

    "qbittorrent" = {
      image = "linuxserver/qbittorrent";

      volumes = [
        "/download/qbittorrent/config:/config"
        "/download/sonarr:/data" #change default save path to: /data/downloads/  [hacky way so that from sonarr use the same download location path]
      ];

      environment = {
        "PUID" = "0";
        "PGID" = "0";
        "WEBUI_PORT" = "8081"; # 8080 is traefik WebUI port
      };
      extraOptions = [
        "--network=host"
      ];
    };

    "jellyfin" = {
      image = "linuxserver/jellyfin";
      volumes = [
        "/download/jellyfin/config:/config"
        "/download/sonarr/media/anime:/data/anime"
      ];

      environment = {
        "PUID" = "0";
        "PGID" = "0";
      };
      extraOptions = [
        "--network=host"
      ];
    };
  };

  services.restic.backups."media" = {
    extraBackupArgs = [
      "--exclude=sonarr/downloads/*" # * keep directory
      "--exclude=sonarr/media/anime/*"
    ];
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [
      "/download"
    ];
    repository = "rclone:r2:backup";
    timerConfig.OnCalendar = "daily";
    pruneOpts = [ "--keep-last 2" ];
  };
}


