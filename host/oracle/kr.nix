{ config, pkgs, ... }:
let

  changeioPort = 5000;
in
{

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

    locations."/changeio" = {
      proxyPass = "http://127.0.0.1:${toString changeioPort}";
    };
  };

  # prometheus main node
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
          targets = map (hostName: "${hostName}.mlyxshi.com:${toString config.services.prometheus.exporters.node.port}") [ "kr" "jp2" "jp4" "us1" "sw" ];
        }];
      }
    ];

  };


  # ChangeDetectionIO
  virtualisation.oci-containers.containers = {
    "changedetectionio" = {
      image = "dgtlmoon/changedetection.io:latest";
      ports = [
        "${toString changeioPort}:${toString changeioPort}/tcp"
      ];

      # environment = { };
      volumes = [ "datastore-volume:/datastore" ];

      extraOptions = [
        "-d"
        "--name changedetectionio"
        "--restart unless-stopped"
      ];
    
    };

  };



}



# podman run -d \
#   --name changedetectionio \
#   --restart unless-stopped \
#   --link playwright-chrome \
#   -p 5000:5000 \
#   -e PLAYWRIGHT_DRIVER_URL=ws://playwright-chrome:3000/ \
#   -v datastore-volume:/datastore \
#   dgtlmoon/changedetection.io


# podman run -d  -p "5000:5000" -v datastore-volume:/datastore --name changedetection.io dgtlmoon/changedetection.io
