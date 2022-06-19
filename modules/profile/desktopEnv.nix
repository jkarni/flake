{ pkgs, lib, config, ... }:
let
  cfg = config.profile.desktopEnv;
in
{

  options = {
    profile.desktopEnv.enable = lib.mkEnableOption "desktop env: install extra fonts, extra permission";
  };

  config = lib.mkIf cfg.enable {

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "sway";
          user = "dominic";
        };
        default_session = initial_session;
      };
    };

  };

}
