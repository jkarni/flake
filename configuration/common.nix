{ config, pkgs, ... }:{


  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.defaultUserShell = pkgs.zsh;

  environment.variables.EDITOR = "vim";

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
    wqy_microhei
  ];


  boot.kernel.sysctl={
    "net.core.default_qdisc"="fq";
    "net.ipv4.tcp_congestion_control"="bbr";
    "net.ipv4.tcp_fastopen"="3";

  };

  system.stateVersion = "22.05";
}
