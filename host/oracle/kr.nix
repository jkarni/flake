{ config, pkgs, ... }:
let

  changeioPort = 5000;
  domain = "kr.mlyxshi.com";
in
{

  imports = [
    ./default.nix
  ];

  # grafana configuration
  services.grafana = {
    enable = true;
    inherit domain;
    port = 2333;
    addr = "127.0.0.1";
  };

  # nginx reverse proxy
  services.nginx.enable = true;
  services.nginx.virtualHosts.${domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
      # workaround https://community.grafana.com/t/after-update-to-8-3-5-origin-not-allowed-behind-proxy/60598/7
      extraConfig = ''
        proxy_set_header Host kr.mlyxshi.com;
      '';
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

    "playwright-chrome" = {
      image = "browserless/chrome";
      ports = [
        "3000:3000"
      ];
    };

    "change-detection-io" = {
      image = "dgtlmoon/changedetection.io";
      ports = [
        "${toString changeioPort}:${toString changeioPort}"
      ];
      volumes = [ "datastore-volume:/datastore" ];
      environment = {
        PLAYWRIGHT_DRIVER_URL = "ws://localhost:3000/";
      };
      extraOptions = [
        "--network=host"
      ];

    };


    "kms-server" = {
      image = "mikolatero/vlmcsd";
      ports = [
        "1688:1688"
      ];
      extraOptions = [
        "--network=host"
      ];
    };

  };



}



# Windows 10 LTSC 2019/2021

# Install product key
#slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D

# Specifies KMS host 
#slmgr.vbs /skms ovh.mlyxshi.com

# Prompts KMS activation attempt.
#slmgr.vbs /ato

# Display detailed license information.
#slmgr.vbs -dlv
