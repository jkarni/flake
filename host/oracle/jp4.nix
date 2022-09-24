{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/qbittorrent-nox.nix #8080
    #../../services/unblock-netease-music.nix #????
  ];
}
