{config, ...}: {
  imports = [
    ./hardware.nix
    ../../os/nixos
  ];

  # Workaround for fixing timeout issue
  # manually reboot once
  systemd.network.wait-online.anyInterface = true;

  systemd.network.networks = {
    dhcp = {
      name = "ens4";
      DHCP = "yes";
    };
  };

  # networking.nameservers = ["1.1.1.1"];
}
