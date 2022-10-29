{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../install.nix
  ];
}
