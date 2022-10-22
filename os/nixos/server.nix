{ config, pkgs, lib, ... }: {

  imports = [
    ./minimal.nix
  ];

  sops.defaultSopsFile = ../../secrets/key.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

}