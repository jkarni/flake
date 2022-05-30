{
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
