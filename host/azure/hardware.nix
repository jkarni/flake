{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/headless.nix")
  ];

  # hyper-v
  initrd.kernelModules = [ "hv_storvsc" ];

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
