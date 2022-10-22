# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/azure-common.nix   <--Outdated
# Use systemd-boot instead

{ modulesPath, ... }: {
  imports = [
    ../../os/nixos/minimal.nix
    (modulesPath + "/profiles/headless.nix")
  ];
  
  # hyper-v: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/hyperv-guest.nix
  virtualisation.hypervGuest.enable = true;  

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.growPartition = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };

  networking.usePredictableInterfaceNames = false;
  
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