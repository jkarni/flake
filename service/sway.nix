{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];


  # Apple Keyboard
  # control->control
  # option->Alt_L->Mod1
  # command->Super_L->Mod4

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [

      swaylock
      swayidle
      wl-clipboard
      mako
      waybar
      foot
      bemenu
      mpv
      firefox-wayland

      xorg.xlsclients #debug xorg.xev xorg.xmodmap 
    ];
  };

  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';

}
