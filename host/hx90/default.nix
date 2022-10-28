{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../os/nixos/desktop.nix
    ../../home/home-manager.nix

    ../../services/ssh-config.nix
  ];

  home-manager.users.root = import ../../home;
  home-manager.users.dominic = import ../../home/sway.nix;

  environment.systemPackages = [
    (pkgs.buildFHSUserEnv {
      name = "snell";
      targetPkgs = pkgs: with pkgs;  [
        glibc
        snell
      ];
      runScript = "/usr/bin/snell-server";
    })
  ];

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };

  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };
}
