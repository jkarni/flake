{ config, pkgs, lib, modulesPath, ... }: {

  imports = [
    ./base.nix
    ./sops.nix
  ];

  documentation.enable = false;
  documentation.nixos.enable = false;
  programs.command-not-found.enable = false;

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
