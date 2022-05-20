{
  imports = [
    ./hardware.nix
    ../../nixos/desktop.nix
    ../../service/desktop.nix
  ];


  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };
}
