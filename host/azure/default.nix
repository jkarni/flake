# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/azure-common.nix
# Use systemd-boot instead

{ modulesPath, ... }: {
  imports = [
    ../../os/nixos/minimal.nix
    (modulesPath + "/virtualisation/azure-common.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.growPartition = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };


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


}