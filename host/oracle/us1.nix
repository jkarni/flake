{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443
    ../../services/nitter.nix
    ../../services/libreddit.nix
    ../../services/invidious.nix
  ];

  # I don't know why default podman-auto-update systemd service configuration is not working
  # create podman-auto-update systemd service and timer manually
  systemd.services.podman-auto-update-self = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman auto-update";
      ExecStartPost = "${pkgs.podman}/bin/podman image prune -f";
    };
  };

  systemd.timers.podman-auto-update-self = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };


  services.telegraf = {
    enable = true;
    extraConfig = {
      inputs = {
        cpu = { };
        disk = {
          ignore_fs = [ "tmpfs" "devtmpfs" "devfs" "overlay" "aufs" "squashfs" ];
        };
        diskio = { };
        mem = { };
        net = { };
        processes = { };
        system = { };
        systemd_units = { };
      };
      outputs = {
        prometheus_client = {
          listen = "127.0.0.0:9273";
          metric_version = 2;
          path = "/metrics";
        };
      };
    };
  };

  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers.telegraf = {
          rule = "Host(`${config.networking.fqdn}`) && Path(`${config.services.telegraf.extraConfig.outputs.prometheus_client.path}`)";
          entryPoints = [ "websecure" ];
          service = "telegraf";
        };

        routers.prometheus = {
          rule = "Host(`${config.networking.fqdn}`) && PathPrefix(`/prom`)";
          entryPoints = [ "websecure" ];
          service = "prometheus";
        };

        services.telegraf.loadBalancer.servers = [{
          url = "http://${config.services.telegraf.extraConfig.outputs.prometheus_client.listen}";
        }];

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
