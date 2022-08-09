{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.profile.developerMode;
in
{
  options = {
    profile.developerMode.enable = lib.mkEnableOption "install extra dev package";
  };
}
