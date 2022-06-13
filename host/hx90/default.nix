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

}
