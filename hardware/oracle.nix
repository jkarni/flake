{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.kernelModules = [ "nvme" ];
  
  fileSystems."/" =
    { device = "/dev/sda2";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/sda1";
      fsType = "vfat";
    };

}

