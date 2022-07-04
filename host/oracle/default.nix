{
  imports = [
    ./hardware.nix
    ../../os/nixos
    ../../home/home-manager.nix
  ];

  home-manager.users.root = import ../../home;

  # Workaround for fixing timeout issue
  # manually reboot once
  systemd.network.wait-online.anyInterface = true;

  systemd.network.networks = {
    dhcp = {
      name = "enp0s3";
      DHCP = "yes";
    };
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = ["systemd"];
    };
  };
}
