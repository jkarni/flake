{ config, pkgs, lib, ... }: {

  sops.defaultSopsFile = ../../secrets/key.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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
      options = "--delete-older-than 7d";
    };
  };


  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;
  users.users.root = {
    hashedPassword = "$6$fwJZwHNLE640VkQd$SrYMjayP9fofIncuz3ehVLpfwGlpUj0NFZSssSy8GcIXIbDKI4JnrgfMZxSw5vxPkXkAEL/ktm3UZOyPMzA.p0";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe" ];
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
    fonts = [
      (pkgs.nerdfonts.override { fonts = [ "RobotoMono" ]; }) # Terminal Font
    ];
    enableDefaultFonts = false; # If Sway is enabled, enableDefaultFonts is true by default <-- I don't need extra default fonts
    # fc-list
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "RobotoMono Nerd Font" ];
      };
    };
  };


  boot.kernelPackages = pkgs.linuxPackages_latest;
  # https://wiki.archlinux.org/title/sysctl
  # https://www.starduster.me/2020/03/02/linux-network-tuning-kernel-parameter/
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = "3"; # shadowsocks tcp fastopen
  };

}
