{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/server-status/client
  ];
}
