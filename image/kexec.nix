# https://github.com/NickCao/netboot/blob/master/flake.nix
{ pkgs, modulesPath, ... }:
let
  # Usage: 
  # install github:mlyxshi/flake hk1 https://linkto/sops/key
  install = pkgs.writeShellApplication {
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

      nixos-install --root /mnt --flake "$FLAKE_URL"#"$HOST_NAME" \
      --no-channel-copy --no-root-passwd \
      --option trusted-public-keys "mlyxshi.cachix.org-1:yc7GPiryyBn0HfiCXdmO1ECWKBhfwrjdIFnRSA4ct7s=" \
      --option substituters "https://mlyxshi.cachix.org" 
    '';
  };
in
{
  imports = [
      (modulesPath + "/profiles/minimal.nix")
      (modulesPath + "/profiles/qemu-guest.nix") # Most VPS, like oracle
      (modulesPath + "/installer/netboot/netboot.nix")
  ];

  boot = {
    initrd.kernelModules = [ "hv_storvsc" ];     # important for azure(hyper-v)
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
  };

  networking.useNetworkd = true;
  networking.firewall.enable = false;

  services.openssh.enable = true;
  services.getty.autologinUser = "root";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe"
  ];


  environment.systemPackages = [
    install
    htop
  ];
}
