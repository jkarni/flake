{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.hm.nixConfigDir;
in
{
  options = {
    hm.nixConfigDir = lib.mkOption {
      type = lib.types.str;
    };
  };
}
