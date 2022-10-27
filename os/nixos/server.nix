{ config, pkgs, lib, modulesPath, ... }: {

  imports = [
    ./base.nix
    ./sops.nix
  ];

  documentation.enable = false;
  documentation.nixos.enable = false;
  programs.command-not-found.enable = false;
}
