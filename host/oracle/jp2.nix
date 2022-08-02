{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;
  services.rss-telegram.enable = true;


  # podman run -p 8080:8080 pan93412/unblock-netease-music-enhanced -e https://music.163.com -o ytdlp bilibili
  # can not use oci-containers directly, virtualisation.oci-containers.containers."xx".cmd will parse to "-e https://music.163.com" "-o ytdlp bilibili", UnblockNeteaseserver do not support quotation marks.

  systemd.services.unblock-netease-music = {
    description = "unblock-netease-music";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.podman}/bin/podman run -p 8080:8080 pan93412/unblock-netease-music-enhanced -e https://music.163.com -o ytdlp bilibili";
    };
  };

  virtualisation.oci-containers.containers = {

    "serverstatus-server" = {
      image = "stilleshan/serverstatus";
      ports = [
        "80:80"
        "35601:35601"
      ];
      volumes = [
        "/var/lib/ServerStatus/config.json:/ServerStatus/server/config.json"
        #"/var/lib/ServerStatus/hotaru-theme:/usr/share/nginx/html"
      ];
    };
  };

}