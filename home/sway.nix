{ pkgs, ... }: {
  imports = [
    ./common.nix
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
    wev
  ];


  # Fix Strange Cursor Size Under Sway
  home.pointerCursor = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  # Firefox can use dark theme toolbar
  gtk = {
    enable = true;
    theme = {
      package = pkgs.materia-theme;
      name = "Materia";
    };
    iconTheme = {
      package = pkgs.numix-icon-theme-circle;
      name = "Numix-Circle";
    };
  };


}
