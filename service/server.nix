{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./shadowsocks.nix
  ];
}
