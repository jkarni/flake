{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];


  # mkdir -p /download/jackett/config
  # mkdir -p /download/qbittorrent/config
  # mkdir -p /download/jellyfin/config
  # mkdir -p /download/sonarr/config
  # mkdir -p /download/sonarr/downloads
  # mkdir -p /download/sonarr/media/anime

  system.activationScripts.makeDownloadDir = pkgs.lib.stringAfter [ "var" ] ''
    [ ! -d /download/jackett/config ] && mkdir -p /download/jackett/config
    [ ! -d /download/qbittorrent/config ] && mkdir -p /download/qbittorrent/config
    [ ! -d /download/jellyfin/config ] && mkdir -p /download/jellyfin/config
    [ ! -d /download/sonarr/config ] && mkdir -p /download/sonarr/config
    [ ! -d /download/sonarr/downloads ] && mkdir -p /download/sonarr/downloads
    [ ! -d /download/sonarr/media/anime ] && mkdir -p /download/sonarr/media/anime
  '';

  systemd.services.traefik.serviceConfig.EnvironmentFile = "/etc/traefik/env";

  services.traefik = {
    enable = true;

    dynamicConfigOptions = {
      middlewares.compress.compress = { };
      tls.options.default = {
        minVersion = "VersionTLS12";
        sniStrict = true;
      };
      http.routers = {
        jackett = {
          rule = "Host(`jackett.mlyxshi.com`)";
          service = "jackett";
        };   

        sonarr = {
          rule = "Host(`sonarr.mlyxshi.com`)";
          service = "sonarr";
        };   
      };

      http.services = {
         jackett.loadBalancer.servers = [{url = "http://localhost:9117";}];
         sonarr.loadBalancer.servers = [{url = "http://localhost:8989";}];
      };
    };

    staticConfigOptions = {
      certificatesResolvers.letsencrypt.acme = {
        dnsChallenge.provider = "cloudflare";
        email = "mlyxdev@gmail.com";
        # "/var/lib/traefik"
        storage = "${config.services.traefik.dataDir}/acme.json";
      };

      api.dashboard = true;
      api.insecure = true;

      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint.to = "websecure";
        };
        websecure = {
          address = ":443";
          http.tls.certResolver = "letsencrypt";
        };
      };
    };
  };


  # https://reorx.com/blog/track-and-download-shows-automatically-with-sonarr

  virtualisation.oci-containers.containers = {

    "jackett" = {
      image = "linuxserver/jackett";
      volumes = [
        "/download/jackett/config:/config"
      ];
      extraOptions = [
        "--network=host"
      ];
    };

    # Port 8989
    sonarr = {
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

    # "qbittorrent" = {
    #   image = "linuxserver/qbittorrent";

    #   volumes = [
    #     "/download/qbittorrent/config:/config"
    #     "/download/sonarr:/data" #change default save path to: /data/downloads/  [hacky way so that from sonarr use the same download location path]
    #   ];

    #   environment = {
    #     "PUID" = "0";
    #     "PGID" = "0";
    #     "WEBUI_PORT" = "8080";
    #   };
    #   extraOptions = [
    #     "--network=host"
    #   ];


    # };

    # # Port 8096
    # "jellyfin" = {
    #   image = "linuxserver/jellyfin";
    #   volumes = [
    #     "/download/jellyfin/config:/config"
    #     "/download/sonarr/media/anime:/data/anime"
    #   ];

    #   environment = {
    #     "PUID" = "0";
    #     "PGID" = "0";
    #   };
    #   extraOptions = [
    #     "--network=host"
    #   ];
    # };



  };


  services.restic.backups."media" = {
    extraBackupArgs = [
      "--exclude=sonarr/downloads"
      "--exclude=sonarr/media/anime"
    ];
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [
      "/download"
    ];
    repository = "rclone:googleshare:backup";
    timerConfig.OnCalendar = "daily";
    pruneOpts = [ "--keep-last 2" ];
  };
}
