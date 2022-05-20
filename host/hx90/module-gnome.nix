{
  imports = [
    ./hardware.nix
    ../../nixos/desktop.nix
    ../../service/gnome.nix
  ];


  systemd.network.networks = {
    dhcp = {
      name = "eno1";
      DHCP = "yes";
    };
  };
}
