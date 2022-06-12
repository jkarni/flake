{ config, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.root = import ../../home/server.nix;

  imports = [
    ./hardware.nix
    ../../nixos/server.nix
    ../../service/server.nix
  ];


  systemd.network.networks = {
    dhcp = {
      name = "enp0s3";
      DHCP = "yes";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9090;

    globalConfig = {
      scrape_interval = "1m";
      evaluation_interval = "1m";
    };

    scrapeConfigs = [
      {
        job_name = "prometheus_exporters_systemd";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9091;
      };
    };

  };


}

