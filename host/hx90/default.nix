{ pkgs, homeStateVersion, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.root = import ../../home/sway-headless.nix;
  home-manager.users.dominic = import ../../home/sway-desktop.nix;

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
