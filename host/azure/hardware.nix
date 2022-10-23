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
  boot.loader.timeout = 3;
  boot.growPartition = true;

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
    autoResize = true;
  };

}