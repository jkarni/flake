{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];


  # only san jose need this, other region do not need, I do not why
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  services.resolved.enable = true;
  services.resolved.dnssec = false;
  services.resolved.llmnr =false;

  services = {
    unblock-netease-music.enable = true;
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile = config.sops.secrets.traefik-cloudflare-env.path;

  services.traefik = {
    enable = true;

    dynamicConfigOptions = {
      middlewares.compress.compress = { };
      tls.options.default = {
        minVersion = "VersionTLS12";
        sniStrict = true;
      };
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

    staticConfigOptions = {
      certificatesResolvers.letsencrypt.acme = {
        dnsChallenge.provider = "cloudflare";
        email = "mlyxdev@gmail.com";
        storage = "${config.services.traefik.dataDir}/acme.json"; # "/var/lib/traefik/acme.json"
      };

      # api.dashboard = true;
      # api.insecure = true;

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


}
