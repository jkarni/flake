{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../cloud
  ];
}
