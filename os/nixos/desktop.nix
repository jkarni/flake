{ pkgs, lib, config, ... }: {

  imports = [
    ./common.nix
  ];

  users.users.dominic = {
    isNormalUser = true;
    description = "mlyxshi";
    hashedPassword = "$6$fwJZwHNLE640VkQd$SrYMjayP9fofIncuz3ehVLpfwGlpUj0NFZSssSy8GcIXIbDKI4JnrgfMZxSw5vxPkXkAEL/ktm3UZOyPMzA.p0";
    extraGroups = [ "wheel" ];
  };

  fonts = {
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "RobotoMono" ]; }) # Terminal Font
      pkgs.SF-Pro # English
      pkgs.PingFang # Chinese/Japanese
    ];
    enableDefaultFonts = false; # If Sway is enabled, enableDefaultFonts is true by default <-- I don't need extra default fonts
    # fc-list
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "RobotoMono Nerd Font" ];
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

}
