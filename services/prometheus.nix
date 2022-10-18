{ config, pkgs, lib, ... }: {

  # https://www.youtube.com/playlist?list=PLLYW3zEOaqlKhRCWqFE7iLRSh3XEFP5gj
  # https://github.com/NickCao/flakes/blob/master/nixos/hel0/prometheus.nix

  sops.secrets.telegram-env = { };

  system.activationScripts.prometheus-alertmanager = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} metric.${config.networking.domain}
      ${pkgs.cloudflare-dns-sync} alert.${config.networking.domain}
    '';
  };

  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers = {
          prometheus = {
            rule = "Host(`metric.${config.networking.domain}`)";
            entryPoints = [ "websecure" ];
            service = "prometheus";
          };

          alertmanager = {
            rule = "Host(`alert.${config.networking.domain}`)";
            entryPoints = [ "websecure" ];
            service = "alertmanager";
          };

        };

        services = {
          prometheus.loadBalancer.servers = [{
            url = "http://127.0.0.1:9090";
          }];
          alertmanager.loadBalancer.servers = [{
            url = "http://127.0.0.1:9093";
          }];
        };
      };
    };
  };


  services.prometheus = {
    enable = true;
    webExternalUrl = "https://metric.${config.networking.domain}";
    listenAddress = "127.0.0.1";
    port = 9090;
    retentionTime = "7d";
    globalConfig = {
      scrape_interval = "1m";
      evaluation_interval = "1m";
    };
    scrapeConfigs = [
      {
        job_name = "Node";
        scheme = "https";
        static_configs = [{
          targets = [
            "us1.${config.networking.domain}"
            "jp2.${config.networking.domain}"
            "kr.${config.networking.domain}"
            "sw.${config.networking.domain}"
          ];
        }];
      }

      {
        job_name = "Miniflux";
        scheme = "https";
        static_configs = [{
          targets = [
            "miniflux.${config.networking.domain}"
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
                summary = "node {{ $labels.instance }} down";
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
      static_configs = [{
        targets = [ "127.0.0.1:9093" ];
      }];
    }];

    alertmanager = {
      enable = true;
      webExternalUrl = "https://alert.${config.networking.domain}";
      listenAddress = "127.0.0.1";
      port = 9093;
      environmentFile = [ config.sops.secrets.telegram-env.path ];
      extraFlags = [ ''--cluster.listen-address=""'' ]; # Disable Alertmanager's default high availability feature
      configuration = {
        receivers = [{
          name = "telegram";
          telegram_configs = [{
            api_url = "https://api.telegram.org";
            bot_token = "$TOKEN";
            chat_id = 337000294;
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
