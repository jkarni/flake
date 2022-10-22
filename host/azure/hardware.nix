# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/azure-common.nix   <--Outdated
# Use systemd-boot instead

{ modulesPath, ... }: {
  imports = [
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

}