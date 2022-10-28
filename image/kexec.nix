{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe"
  ];

  # To Do: Automate fully
  # justdoit = pkgs.writeScriptBin "justdoit" ''
  #   #!${pkgs.stdenv.shell}
  #   dd if=/dev/zero of=/dev/sda bs=512 count=10000
  #   sfdisk /dev/sda <<EOF
  #   label: dos
  #   device: /dev/sda
  #   unit: sectors
  #   /dev/sda1 : start=        2048, size=3145728, type=83
  #   EOF
  #   mkfs.ext4 /dev/sda1
  #   mount -v /dev/sda1 /mnt
  #   nixos-generate-config --root /mnt
  #   cp -v ${./target-config.nix} /mnt/etc/nixos/configuration.nix
  #   nixos-install -j 4
  #   umount /mnt
  # '';
}