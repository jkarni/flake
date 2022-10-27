{ config, pkgs, lib, modulesPath, ... }: {

  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ./base.nix
    ./sops.nix
  ];
}
