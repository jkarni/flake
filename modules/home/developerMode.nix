{ pkgs, lib, config, ... }:
let
  cfg = config.home.developerMode;
in
{
  options = {
    home.developerMode.enable =  lib.mkEnableOption "install extra dev package";
  };
}
