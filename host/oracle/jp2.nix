{ config, pkgs, ... }: {

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

  };

}