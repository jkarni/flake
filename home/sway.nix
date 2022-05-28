{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];

  # Apple Keyboard
  # control->control
  # option->Alt_L->Mod1
  # command->Super_L->Mod4
  xdg.configFile."sway/config".source = ../config/sway/config;
  xdg.configFile."waybar/config".source = ../config/waybar/config;
  xdg.configFile."foot/foot.ini".source = ../config/foot/foot.ini;


  # Fix Strange Cursor Size Under Sway
  home.pointerCursor = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };


  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    mako
    waybar
    foot
    pavucontrol
    bemenu
    mpv
    baobab
    firefox-wayland

    xorg.xlsclients #debug xorg.xev xorg.xmodmap 
  ];
}
