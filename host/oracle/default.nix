{
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

