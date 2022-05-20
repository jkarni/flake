{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];
  xdg.configFile."waybar/config".source = ../config/waybar/config;
  xdg.configFile."sway/config".source = ../config/sway/config;
  xdg.configFile."foot/foot.ini".source = ../config/foot/foot.ini;


  # Fix Strange Cursor Size Under Sway
  home.pointerCursor = {
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };
}
