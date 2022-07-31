{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];


  # mkdir -p /download/jackett/config
  # mkdir -p /download/jackett/downloads

  # mkdir -p /download/sonarr/config
  # mkdir -p /download/sonarr/downloads

  # mkdir -p /download/qbittorrent/config

 

  virtualisation.oci-containers.containers = {
    # Port 9117
    "jackett" = {
      image = "linuxserver/jackett";
      volumes = [
        "/download/jackett/config:/config"
        "/download/jackett/downloads:/downloads"  #torrent
      ];
      extraOptions = [
        "--network=host"
      ];
    };

    # Port 8989
    sonarr = {
      image = "linuxserver/sonarr";
      volumes = [
        "/download/sonarr/config:/config"
        "/download/sonarr:/data"  # real download file
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
        "/download/sonarr:/data"
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
