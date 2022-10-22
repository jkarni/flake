{ modulesPath, ... }: {
  imports = [
    ../../os/nixos/minimal.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub.device = "/dev/sda";
  fileSystems."/" = { device = "/dev/sda2"; fsType = "ext4"; };

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };

  systemd.network.wait-online.anyInterface = true;
  systemd.network.networks = {
    dhcp = {
      name = "eth0";
      DHCP = "yes";
    };
  };

  # networking.nameservers = ["1.1.1.1"];
}
