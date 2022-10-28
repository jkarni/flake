{ config, pkgs, lib, ... }: {

  imports = [
    ./base.nix
  ];

  sops.defaultSopsFile = ../../secrets/key.yaml;
  # This will automatically import SSH keys as age keys
  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.age.keyFile = "/var/lib/sops/age.key";

  environment.systemPackages = with pkgs; [
    (writeShellApplication {
      name = "update";
      runtimeInputs = with pkgs; [ git ];
      text = ''
        if [ ! -d "/etc/flake" ]
        then 
          git clone git@github.com:mlyxshi/flake /etc/flake
        fi
    
        cd /etc/flake 
        git pull 
        nixos-rebuild switch --flake /etc/flake# -v -L
      '';
    })

  ];
}
