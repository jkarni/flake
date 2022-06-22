{ pkgs, lib, config, ... }:
let
  cfg = config.hm.stateVersion;
in
{
  options = {
    hm.stateVersion =  lib.mkOption {
      type = lib.types.str;
    };
  };
}