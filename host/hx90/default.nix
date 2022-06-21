{ pkgs, ... }@args: {

  imports = [
    ./hardware.nix
    ../../nixos/desktop.nix
    ../../home/home-manager.nix
  ];

  home-manager.users.root = import ../../home;
  home-manager.users.dominic = import ../../home/sway.nix;

  home-manager.sharedModules = [
    {
      home.developerMode.enable = true;
    }
  ];


  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };

}
