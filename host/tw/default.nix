{config, ...}: {
  imports = [
    ./hardware.nix
    ../../os/nixos
    #../../home/home-manager.nix
  ];

  #home-manager.users.root = import ../../home;

  # Workaround for fixing timeout issue
  # manually reboot once
  systemd.network.wait-online.anyInterface = true;

  systemd.network.networks = {
    dhcp = {
      name = "ens4";
      DHCP = "yes";
    };
  };

  virtualisation.podman.enable = true;
  # networking.nameservers = ["1.1.1.1"];
}
