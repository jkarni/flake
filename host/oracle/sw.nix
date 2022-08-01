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


  services.traefik.enable = true;
  services.traefik.group = "docker";
  services.traefik.staticConfigOptions = {
    api.dashboard = true;
    api.insecure = true;
    entryPoints = {
      web = {
        address = ":80";
      };
      websecure = {
        address = ":443";
      };
    };
    # providers.docker = {
    #   endpoint = "unix:///var/run/docker.sock";
    #   exposedByDefault = false;
    # };
    # certificatesResolvers.cf.acme = {
    #   email = "mlyxdev@gmail.com";
    #   storage = "/srv/traefik/acme.json";
    #   dnsChallenge = {
    #     provider = "cloudflare";
    #     resolvers = [ "1.1.1.1:53" "1.0.0.1:53" ];
    #   };
    # };
  };

  services.traefik.dynamicConfigOptions = {
    # http.middlewares = {
    #   compress.compress = {};
    # };

    # http.middlewares = {
    #   web-redirect.redirectScheme.scheme = "https";
    # };
    tls.options.default = {
      minVersion = "VersionTLS12";
      cipherSuites = [
        "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
        "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
        "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
        "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
        "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305"
        "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305"
      ];
    };
  };


  # https://reorx.com/blog/track-and-download-shows-automatically-with-sonarr

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers = {

    # # Port 9117
    # "jackett" = {
    #   image = "linuxserver/jackett";
    #   volumes = [
    #     "/download/jackett/config:/config"
    #   ];
    #   extraOptions = [
    #     "--network=host"
    #   ];
    # };

    # # Port 8989
    # sonarr = {
    #   image = "linuxserver/sonarr";
    #   volumes = [
    #     "/download/sonarr:/data"
    #     "/download/sonarr/config:/config"
    #   ];
    #   environment = {
    #     "PUID" = "0";
    #     "PGID" = "0";
    #   };
    #   extraOptions = [
    #     "--network=host"
    #   ];
    # };

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
