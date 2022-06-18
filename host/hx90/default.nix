{ config, pkgs, developerMode, homeStateVersion, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit developerMode homeStateVersion; };
  home-manager.users.root = import ../../home/sway-headless.nix;
  home-manager.users.dominic = import ../../home/sway-desktop.nix;

  imports = [
    ./hardware.nix
    ../../nixos/desktop.nix
    ../../service/sway.nix
    ../../secrets
  ];


  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };

}
