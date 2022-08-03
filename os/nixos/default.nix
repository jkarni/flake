{
  config,
  pkgs,
  lib,
  ...
}: let
  hashedPassword = "$6$fwJZwHNLE640VkQd$SrYMjayP9fofIncuz3ehVLpfwGlpUj0NFZSssSy8GcIXIbDKI4JnrgfMZxSw5vxPkXkAEL/ktm3UZOyPMzA.p0";
in {
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      substituters = [
        "https://mlyxshi.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "mlyxshi.cachix.org-1:yc7GPiryyBn0HfiCXdmO1ECWKBhfwrjdIFnRSA4ct7s="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  users = {
    defaultUserShell = pkgs.zsh;

    users =
      {
        root = {
          inherit hashedPassword;
          openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe"];
        };
      }
      // lib.optionalAttrs config.profile.desktopEnv.enable {
        dominic = {
          isNormalUser = true;
          description = "mlyxshi";
          inherit hashedPassword;
          extraGroups = ["wheel"];
        };
      };
  };

  # sshd (server)
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "bat";
  };

  fonts = {
    fonts =
      [
        (pkgs.nerdfonts.override {fonts = ["RobotoMono"];}) # Terminal Font
      ]
      ++ lib.optionals config.profile.desktopEnv.enable [
        # The essence of Apple
        pkgs.SF-Pro # English
        pkgs.PingFang # Chinese/Japanese
      ];

    enableDefaultFonts = false; # If Sway is enabled, enableDefaultFonts is true by default <-- I don't need extra default fonts

    # fc-list
    fontconfig = {
      enable = true;
      defaultFonts =
        {
          monospace = ["RobotoMono Nerd Font"];
        }
        // lib.optionalAttrs config.profile.desktopEnv.enable {
          sansSerif = ["SF Pro"];
          serif = ["SF Pro"];
        };
    };
  };

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = "3";
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };
}
