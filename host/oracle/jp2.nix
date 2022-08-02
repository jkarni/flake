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

    "nodestatus-server" = {
      image = "cokemine/nodestatus";
      ports = [
        "35601:35601"
      ];
      volumes = [
        "/var/lib/NodeStatus/server:/usr/local/NodeStatus/server"
        "/tmp:/tmp:rw"
      ];
      environment = {
        PORT = 35601;
        VERBOSE = true;
        PING_INTERVAL = 30;
        TZ = Asia/Shanghai;

        USE_PUSH = "true";
        USE_IPC = "true";
        USE_WEB = "true";

        WEB_THEME = "hotaru-theme";
        WEB_TITLE = "Server Status";
        WEB_SUBTITLE = "Servers' Probes Set up with NodeStatus";
        WEB_HEADTITLE = "NodeStatus";

        WEB_USERNAME = "admin";
        WEB_PASSWORD = "";
        WEB_SECRET = "";

        PUSH_TIMEOUT = 120;
        PUSH_DELAY = 15;

      };
    };

  };
}



