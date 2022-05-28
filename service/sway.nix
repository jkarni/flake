{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';

}
