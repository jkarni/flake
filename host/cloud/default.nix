{ config, pkgs, lib, ... }: {

  system.build.install = pkgs.writeShellApplication {
    name = "install";
    text = ''
      FLAKE_URL=$1
      HOST_NAME=$2
      KEY_URL=$3

      sfdisk /dev/sda <<EOT
      label: gpt
      type="BIOS boot",        name="BOOT",  size=512M
      type="Linux filesystem", name="NIXOS", size=+
      EOT
      sleep 3

      mkfs.fat -F32 /dev/sda1
      mkfs.ext4 /dev/sda2

      mkdir /mnt
      mount /dev/sda2 /mnt
      mkdir /mnt/boot
      mount /dev/sda1 /mnt/boot

      mkdir -p /mnt/var/lib/sops/
      curl -s "$KEY_URL" -o /mnt/var/lib/sops/age.key

      nixos-install --root /mnt --system ${config.system.build.toplevel} \
      --no-channel-copy --no-root-passwd \
      --option trusted-public-keys "mlyxshi.cachix.org-1:yc7GPiryyBn0HfiCXdmO1ECWKBhfwrjdIFnRSA4ct7s=" \
      --option substituters "https://mlyxshi.cachix.org" -v
    '';
  };
}
