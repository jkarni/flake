{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];


  # mkdir -p /download/jackett/config

  # mkdir -p /download/sonarr/config
  # mkdir -p /download/sonarr/downloads
  # mkdir -p /download/sonarr/media/tv

  # mkdir -p /download/qbittorrent/config

 

  virtualisation.oci-containers.containers = {
    # Port 9117
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
        #"/download/sonarr:/data"
        "/download/sonarr/config:/config"
        "/download/data:/data"
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
        #"/download/sonarr:/data"   #change default save path to: /data/downloads/  [real path: /download/sonarr/downloads ]
        "/download/data/downloads:/downloads"
      ];

      environment = {
        "PUID" = "0";
        "PGID" = "0";
        "WEBUI_PORT"="8080";
      };
      extraOptions = [
        "--network=host"
      ];


    };



  };
}
