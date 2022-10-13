{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/qbittorrent-nox.nix #8080
  ];
}
