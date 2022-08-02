{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];

  systemd.services.traefik.serviceConfig.EnvironmentFile = config.sops.secrets.traefik-cloudflare-env.path;

  services.traefik = {
    enable = true;

    dynamicConfigOptions = {
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

      http.middlewares = {
        web-redirect.redirectScheme.scheme = "https";
      };
    };

    staticConfigOptions = {
      # api.dashboard = true;
      # api.insecure = true;

      entryPoints = {
        web = {
          address = ":80";
        };
        websecure = {
          address = ":443";
          http.tls.certResolver = "letsencrypt";
        };
      };

      certificatesResolvers.letsencrypt.acme = {
        dnsChallenge.provider = "cloudflare";
        email = "blackhole@mlyxshi.com";
        storage = "${config.services.traefik.dataDir}/acme.json"; # "/var/lib/traefik/acme.json"
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
