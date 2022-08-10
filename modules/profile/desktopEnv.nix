{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.profile.desktopEnv;
in
{
  options = {
    profile.desktopEnv.enable = lib.mkEnableOption "desktop env: install extra fonts, extra permission";
  };

  config = lib.mkIf cfg.enable {

    users.users.dominic = {
      isNormalUser = true;
      description = "mlyxshi";
      hashedPassword = "$6$fwJZwHNLE640VkQd$SrYMjayP9fofIncuz3ehVLpfwGlpUj0NFZSssSy8GcIXIbDKI4JnrgfMZxSw5vxPkXkAEL/ktm3UZOyPMzA.p0";
      extraGroups = [ "wheel" ];
    };


    fonts = {
      # The essence of Apple
      fonts = [
        pkgs.SF-Pro # English
        pkgs.PingFang # Chinese/Japanese
      ];
      # fc-list
      fontconfig = {
        defaultFonts = {
          sansSerif = [ "SF Pro" ];
          serif = [ "SF Pro" ];
        };
      };
    };

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
