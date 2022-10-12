{ config, pkgs, lib, ... }: {
  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers.prometheus = {
          rule = "Host(`${config.networking.fqdn}`) && PathPrefix(`/prom`)";
          entryPoints = [ "websecure" ];
          service = "prometheus";
        };

        services.prometheus.loadBalancer.servers = [{
          url = "http://${config.services.prometheus.listenAddress}:${builtins.toString config.services.prometheus.port}";
        }];
      };
    };
  };


  services.prometheus = {
    enable = true;
    webExternalUrl = "https://${config.networking.fqdn}/prom";
    listenAddress = "127.0.0.1";
    port = 9090;
    retentionTime = "7d";
    globalConfig = {
      scrape_interval = "1m";
      evaluation_interval = "1m";
    };
    scrapeConfigs = [
      {
        job_name = "metrics";
        scheme = "https";
        static_configs = [{
          targets = [
            "us1.mlyxshi.com"
          ];
        }];
      }
    ];
  };
}
