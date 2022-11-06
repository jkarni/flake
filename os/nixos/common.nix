{ config, pkgs, lib, ... }: {

  imports = [
    ./base.nix
  ];

  # Fix sops fresh install activation failure
  sops.age.sshKeyPaths = [ ];
  sops.gnupg.sshKeyPaths = [ ];

  sops.defaultSopsFile = ../../secrets/key.yaml;
  sops.age.keyFile = "/var/lib/sops/age.key";

  environment.systemPackages =  [
    (pkgs.writeShellApplication {
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
