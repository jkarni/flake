{ pkgs, ... }: {
  imports = [
    ./common.nix
    ./ui.nix
    ./mpv.nix
    ./firefox.nix
  ];

  # Apple Keyboard
  # control->control
  # option->Alt_L->Mod1
  # command->Super_L->Mod4
  xdg.configFile."sway/config".source = ../config/sway/config;
  xdg.configFile."foot/foot.ini".source = ../config/foot/foot.ini;

  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    pavucontrol
    baobab

    # https://codeberg.org/dnkl   <-- my favourite developer in wayland. Minimalism! 
    foot
    fuzzel

    xorg.xlsclients #xorg.xmodmap
    appimage-run
    wev
  ];
}
