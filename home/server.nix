{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs;  [
    shadowsocks-libev

  ];

}