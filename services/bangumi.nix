{ config, pkgs, lib, ... }: {

  sops.secrets.restic-password = { };
  sops.secrets.rclone-config = { };

  # restic restore backup to create basic configuration tree directory structure

  # https://reorx.com/blog/track-and-download-shows-automatically-with-sonarr
  virtualisation.oci-containers.containers = {

    "jackett" = {
      image = "linuxserver/jackett";
      volumes = [
        "/download/jackett/config:/config"
      ];
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.jackett.rule=Host(`jackett.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.jackett.entrypoints=web"
        "--label"
        "traefik.http.routers.jackett.middlewares=web-redirect@file"

        "--label"
        "traefik.http.routers.websecure-jackett.rule=Host(`jackett.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-jackett.entrypoints=websecure"
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
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.sonarr.rule=Host(`sonarr.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.sonarr.entrypoints=web"
        "--label"
        "traefik.http.routers.sonarr.middlewares=web-redirect@file"

        "--label"
        "traefik.http.routers.websecure-sonarr.rule=Host(`sonarr.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-sonarr.entrypoints=websecure"
      ];
    };

    "qbittorrent" = {
      image = "linuxserver/qbittorrent";

      volumes = [
        "/download/qbittorrent/config:/config"
        "/download/sonarr:/data" #change default save path to: /data/downloads/  [hacky way: from sonarr's view, use the same download location path as qb]
      ];

      environment = {
        "PUID" = "0";
        "PGID" = "0";
      };
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.qbittorrent.rule=Host(`qb.media.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.qbittorrent.entrypoints=web"
        "--label"
        "traefik.http.services.qbittorrent.loadbalancer.server.port=8080"
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
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.jellyfin.rule=Host(`jellyfin.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.jellyfin.entrypoints=web"
        "--label"
        "traefik.http.routers.jellyfin.middlewares=web-redirect@file"

        "--label"
        "traefik.http.routers.websecure-jellyfin.rule=Host(`jellyfin.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-jellyfin.entrypoints=websecure"
      ];
    };
  };

  systemd.services.podman-jackett.preStart = lib.mkAfter ''
    ${pkgs.cloudflare-dns-sync} jackett.${config.networking.domain}
  '';
  systemd.services.podman-sonarr.preStart = lib.mkAfter ''
    ${pkgs.cloudflare-dns-sync} sonarr.${config.networking.domain}
  '';
  systemd.services.podman-qbittorrent.preStart = lib.mkAfter ''
    ${pkgs.cloudflare-dns-sync} qb.media.${config.networking.domain}
  '';
  systemd.services.podman-jellyfin.preStart = lib.mkAfter ''
    ${pkgs.cloudflare-dns-sync} jellyfin.${config.networking.domain}
  '';

  services.restic.backups."media" = {
    extraBackupArgs = [
      "--exclude=sonarr/downloads/*" # * keep directory
      "--exclude=sonarr/media/anime/*"
    ];
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [ "/download" ];
    repository = "rclone:r2:backup";
    timerConfig.OnCalendar = "02:00";
    pruneOpts = [ "--keep-last 2" ];
  };
}
