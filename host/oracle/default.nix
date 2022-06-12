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
    retentionTime = "7d";

    globalConfig = {
      scrape_interval = "1m";
      evaluation_interval = "1m";
    };

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9091;
      };
    };

    scrapeConfigs = [
      {
        job_name = "metrics";
        static_configs = [{
          targets = [
            "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
          ];
        }];
      }
    ];

  };


}

