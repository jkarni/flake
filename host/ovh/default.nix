# low-end kimsufi
{ config, pkgs, homeStateVersion, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit homeStateVersion;};
  home-manager.users.root = import ../../home/server.nix;

  imports = [
    ./hardware.nix
    ../../nixos/server.nix
    ../../service/server.nix
    ../../secrets
  ];

  systemd.network.wait-online.anyInterface = true;

  systemd.network.networks = {
    dhcp = {
      name = "eno0";
      DHCP = "yes";
    };
  };

  #  
  services.nginx.enable = true;
  services.nginx.virtualHosts."ovh.mlyxshi.com" = {
    root = "/var/www/myhost.org";
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
    };
  };


}