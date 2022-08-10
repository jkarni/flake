{ config, ... }: {
  imports = [
    ./hardware.nix
    ../../os/nixos
  ];


  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };

  # Workaround for fixing timeout issue
  # manually reboot once
  systemd.network.wait-online.anyInterface = true;

  systemd.network.networks = {
    dhcp = {
      name = "eno0";
      DHCP = "yes";
    };
  };

  # networking.nameservers = ["1.1.1.1"];
}
