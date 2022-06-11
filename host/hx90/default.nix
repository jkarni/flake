{ config, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.root = import ../../home/sway-headless.nix;
  home-manager.users.dominic = import ../../home/sway-desktop.nix;

  imports = [
    ./hardware.nix
    ../../nixos/desktop.nix
    ../../service/sway.nix
  ];


  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };

  
  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "localhost";
    port = 2333;
    addr = "127.0.0.1";
  };

  # nginx reverse proxy
  services.nginx.enable = true;
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };

}
