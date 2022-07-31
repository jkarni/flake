{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];


  services = {
    qbittorrent-nox.enable = true;

    libreddit = {
      address = "127.0.0.1";
      enable = true;
      port = 8081;
    };

    traefik = {
      dynamicConfigOptions.http = {
        routers.libreddit = {
          rule = "Host(`reddit.mlyxshi.com`)";
          service = "libreddit";
        };
        services.libreddit.loadBalancer.servers = [{ url = "http://${config.services.libreddit.address}:${builtins.toString config.services.libreddit.port}"; }];
      };
    };


  };
}
