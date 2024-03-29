{ config, pkgs, lib, ... }: {

  imports = [
    ./common.nix
    ../../script/cloudflare-dns-sync.nix
  ];

  documentation.enable = false;
  documentation.nixos.enable = false;
  programs.command-not-found.enable = false;
}
