{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.root = import ../../home/server.nix;

  imports = [
    ./hardware.nix
    ../../nixos/server.nix
    ../../service/server.nix
  ];


  systemd.network.networks = {
    dhcp = {
      name = "enp0s3";
      DHCP = "yes";
    };
  };
}

