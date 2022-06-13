{ config, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.root = import ../../home/server.nix;

  imports = [
    ./hardware.nix
    ../../nixos/server.nix
    ../../service/server.nix
  ];

  systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [ "" "${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online --any" ];
  systemd.network.networks = {
    dhcp = {
      name = "enp0s3";
      DHCP = "yes";
    };
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
    };
  };


}

