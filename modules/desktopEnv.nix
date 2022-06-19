{ pkgs, lib, config, ... }:
let
  cfg = config.env.desktop;
in
{

  options = {
    env.desktop.enable =  lib.mkEnableOption "desktop env: install extra fonts, extra permission";
  };
}