{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/server-status/server/default.nix #80
    ../../services/qbittorrent-nox.nix #8080
  ];
}
