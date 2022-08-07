{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;


    
      # libreddit.loadBalancer.servers = [{ url = "http://localhost:8082"; }];
      # nitter.loadBalancer.servers = [{ url = "http://localhost:8083"; }];
      # youtube.loadBalancer.servers = [{ url = "http://localhost:8084"; }];


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
      ExecStart = "${pkgs.podman}/bin/podman run --name='unblock-netease-music' -p 8899:8080 pan93412/unblock-netease-music-enhanced -e https://music.163.com -o ytdlp bilibili";
    };
  };

  sops.secrets.cloudflared-tunnel-env = {};
  systemd.services.cloudflared = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "systemd-resolved.service" ];
    serviceConfig = {
      #ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=$TOKEN";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo ggg > /tmp/cloudflared'";
      # Restart = "always";
      EnvironmentFile = "/run/secrets/cloudflared-tunnel-env";
    };
  };


}