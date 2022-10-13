{ config, pkgs, lib, ... }: {

  sops.secrets.telegram-env = { };

  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers = {
          prometheus = {
            rule = "Host(`${config.networking.fqdn}`) && PathPrefix(`/prom`)";
            entryPoints = [ "websecure" ];
            service = "prometheus";
          };

          alertmanager = {
            rule = "Host(`${config.networking.fqdn}`) && PathPrefix(`/alert`)";
            entryPoints = [ "websecure" ];
            service = "alertmanager";
          };

        };

        services = {
          prometheus.loadBalancer.servers = [{
            url = "http://${config.services.prometheus.listenAddress}:${builtins.toString config.services.prometheus.port}";
          }];
          alertmanager.loadBalancer.servers = [{
            url = "http://${config.services.prometheus.alertmanager.listenAddress}:${builtins.toString config.services.prometheus.alertmanager.port}";
          }];
        };
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
            "jp2.mlyxshi.com"
            "kr.mlyxshi.com"
            "sw.mlyxshi.com"
          ];
        }];
      }
    ];
    rules = [
      (builtins.toJSON {
        groups = [{
          name = "metrics";
          rules = [
            {
              alert = "NodeDown";
              expr = "up == 0";
              for = "3m";
              annotations = {
                summary = "node {{ $labels.host }} down for job {{ $labels.job }}";
              };
            }
            {
              alert = "UnitFailed";
              expr = "systemd_units_active_code == 3";
              for = "2m";
              annotations = {
                summary = "unit {{ $labels.name }} on {{ $labels.host }} failed";
              };
            }
          ];
        }];
      })
    ];

    alertmanagers = [{
      path_prefix = "/alert";
      static_configs = [{
        targets = [ "${config.services.prometheus.alertmanager.listenAddress}:${builtins.toString config.services.prometheus.alertmanager.port}" ];
      }];
    }];

    alertmanager = {
      enable = true;
      webExternalUrl = "https://${config.networking.fqdn}/alert";
      listenAddress = "127.0.0.1";
      port = 9093;
      environmentFile = [ config.sops.secrets.telegram-env.path ];
      extraFlags = [ ''--cluster.listen-address=""'' ];
      configuration = {
        receivers = [{
          name = "telegram";
          telegram_configs = [{
            api_url = "https://api.telegram.org";
            bot_token = "$TOKEN";
            chat_id = 337000294;
            # message = "";
            parse_mode = "HTML";
          }];
        }];
        route = {
          receiver = "telegram";
        };
      };
    };
  };
}
