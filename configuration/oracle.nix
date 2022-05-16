{ config, pkgs, ... }:

{
  imports = [
    ./server.nix
  ];


  systemd.network.networks = {
    dhcp = {
      name = "enp0s3";
      DHCP = "yes";
    };
  };
}
