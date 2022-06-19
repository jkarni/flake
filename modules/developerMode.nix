{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.mode.developerMode;
in
{

  options = {
    mode.developerMode = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable developerMode will install many programming languange packages.
        '';
      };
    };

  };
}
