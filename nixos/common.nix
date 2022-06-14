{ config, pkgs, lib, ... }: {


  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      substituters = [
        "https://mlyxshi.cachix.org"
      ];
      trusted-public-keys = [
        "mlyxshi.cachix.org-1:yc7GPiryyBn0HfiCXdmO1ECWKBhfwrjdIFnRSA4ct7s="
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
    };

  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.defaultUserShell = pkgs.zsh;
  users.users.root.hashedPassword = "$6$fwJZwHNLE640VkQd$SrYMjayP9fofIncuz3ehVLpfwGlpUj0NFZSssSy8GcIXIbDKI4JnrgfMZxSw5vxPkXkAEL/ktm3UZOyPMzA.p0";

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";

  fonts = {
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "RobotoMono" ]; }) # Terminal Font
    ] ++ lib.optionals (config.users.users ? dominic) [
      # If desktop user dominic is defined, add desktop fonts
      # The essence of Apple
      pkgs.SF-Pro # English
      pkgs.PingFang # Chinese/Japanese
    ];

    enableDefaultFonts = false; # If Sway is enabled, enableDefaultFonts is true by default <-- I don't need extra default fonts

    # fc-list
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "RobotoMono Nerd Font" ];
      } // lib.optionalAttrs (config.users.users ? dominic) {
        sansSerif = [ "SF Pro" ];
        serif = [ "SF Pro" ];
      };
    };

  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "bat";
  };

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = "3";
  };

  system.stateVersion = "22.05";
}
