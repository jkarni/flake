{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];

  # mkdir -p /download/sonarr/config
  # mkdir -p /download/jackett/config
  # mkdir -p /download/jackett/downloads
  virtualisation.oci-containers.containers = {
    # Port 9117
    "jackett" = {
      image = "linuxserver/jackett";
      volumes = [
        "/download/jackett/config:/config"
        "/download/jackett/downloads:/downloads"
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
        "/download/sonarr:/anime"
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
}
