{ pkgs, ... }: {
  imports = [
    ./common.nix
    ./ui.nix
    ./firefox.nix
  ];

  # Apple Keyboard
  # control->control
  # option->Alt_L->Mod1
  # command->Super_L->Mod4
  xdg.configFile."sway/config".source = ../config/sway/config;
  xdg.configFile."waybar/config".source = ../config/waybar/config;
  xdg.configFile."foot/foot.ini".source = ../config/foot/foot.ini;


  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    mako
    waybar
    foot
    pavucontrol
    bemenu
    baobab

    xorg.xlsclients #debug wev xorg.xmodmap 
  ];
}