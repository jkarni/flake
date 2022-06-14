{ config, pkgs, ... }: {

  imports = [
    ./default.nix
  ];

  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "kr.mlyxshi.com";
    port = 2333;
    addr = "127.0.0.1";
  };

  # nginx reverse proxy
  services.nginx.enable = true;
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
      # workaround https://community.grafana.com/t/after-update-to-8-3-5-origin-not-allowed-behind-proxy/60598/7
      extraConfig = ''
        proxy_set_header Host kr.mlyxshi.com;
      '';
    };
  };

  services.prometheus = {
    enable = true;
    retentionTime = "365d";

    globalConfig = {
      scrape_interval = "1m";
      evaluation_interval = "1m";
    };

    scrapeConfigs = [
      {
        job_name = "metrics";
        static_configs = [{
          targets = builtin.map (hostName: "${hostName}.mlyxshi.com:${toString config.services.prometheus.exporters.node.port}") [ "kr" "jp2" "jp4" "us1" "sw" ];
        }];
      }
    ];

  };


}
