{ pkgs, lib, config, ... }:
let
  cfg = config.profile.desktopEnv;
in
{

  options = {
    profile.desktopEnv.enable =  lib.mkEnableOption "desktop env: install extra fonts, extra permission";
  };
}