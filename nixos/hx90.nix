{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
  ];


  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };
}
