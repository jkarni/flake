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
  # xdg.configFile."yambar/config.yml".source = ../config/yambar/config.yml;


  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    pavucontrol
    baobab

    # https://codeberg.org/dnkl   <-- my favourite developer in wayland. Minimalism! 
    foot
    yambar
    fuzzel

    xorg.xlsclients #debug wev xorg.xmodmap 
  ];
}
