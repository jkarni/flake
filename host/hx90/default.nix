{ pkgs, homeStateVersion, ... }: {

  imports = [
    ./hardware.nix
    ../../nixos/desktop.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;

  home-manager.users.root = import ../../home;
  home-manager.users.dominic = import ../../home/sway.nix;

  home-manager.extraSpecialArgs = { inherit homeStateVersion; };
  home-manager.sharedModules = [
    ../../modules/home

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
