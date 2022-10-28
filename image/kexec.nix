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

      sfdisk /dev/vda <<EOT
      label: gpt
      type="BIOS boot",        name="BOOT",  size=512M
      type="Linux filesystem", name="NIXOS", size=+
      EOT
      sleep 2

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
      (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  boot = {
    # important for azure(hyper-v)
    initrd.kernelModules = [ "hv_storvsc" ];
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
  };

  networking.useNetworkd = true;
  networking.firewall.enable = false;

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe"
  ];


  environment.systemPackages = [
    install
  ];
}
