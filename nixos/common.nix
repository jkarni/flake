{ config, pkgs, lib, ... }: {


  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/misc/nix-daemon.nix
    # neovim binary cache
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe" ];

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

    # fc-list
    fontconfig.defaultFonts = {
      monospace = [ "RobotoMono Nerd Font" ];
    } // lib.optionalAttrs (config.users.users ? dominic) {
      sansSerif = [ "SF Pro" ];
      serif = [ "SF Pro" ];
    };

    enableDefaultFonts = lib.mkForce false; # If Sway is enabled, enableDefaultFonts is true by default
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
