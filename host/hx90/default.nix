{ pkgs, homeStateVersion, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.verbose = true;

  home-manager.users.root = import ../../home/common.nix;
  home-manager.users.dominic = import ../../home/sway.nix;

  home-manager.extraSpecialArgs = { inherit homeStateVersion; };
  home-manager.sharedModules = [
    ../../modules/home/developerMode.nix

    {
      home.developerMode.enable = true;
    }
  ];

  imports = [
    ./hardware.nix
    ../../nixos/desktop.nix
  ];


  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };

}
