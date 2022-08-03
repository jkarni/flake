{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;

  services.traefik-cloudflare.enable = true;
  services.traefik.dynamicConfigOptions = {
    http.routers = {
      libreddit.rule = "Host(`reddit.mlyxshi.com`)";
      libreddit.service = "libreddit";

      nitter.rule = "Host(`twitter.mlyxshi.com`)";
      nitter.service = "nitter";

      youtube.rule = "Host(`youtube.mlyxshi.com`)";
      youtube.service = "youtube";
    };

    http.services = {
      libreddit.loadBalancer.servers = [{ url = "http://localhost:8082"; }];
      nitter.loadBalancer.servers = [{ url = "http://localhost:8083"; }];
      youtube.loadBalancer.servers = [{ url = "http://localhost:8084"; }];
    };
  };

  services.libreddit = {
    enable = true;
    address = "127.0.0.1";
    port = 8082;
  };

  services.nitter = {
    enable = true;
    preferences = {
      replaceTwitter = config.services.nitter.server.hostname;
      theme = "Auto";
    };
    server = {
      address = "127.0.0.1";
      https = true;
      hostname = "twitter.mlyxshi.com";
      port = 8083;
    };
  };

  services.invidious = {
    enable = true;
    domain = "youtube.mlyxshi.com";
    port = 8084;
  };




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
}
