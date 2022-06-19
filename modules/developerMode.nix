{ pkgs, lib, config, ... }:
let
  cfg = config.mode.developerMode;
in
{

  options = {
    # https://github.com/NixOS/nixpkgs/blob/master/lib/options.nix
    mode.developerMode.enable =  lib.mkEnableOption "install extra dev package";

  };
}
