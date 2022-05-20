{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];
  xdg.configFile."waybar/config".source = ../config/waybar/config;
  xdg.configFile."sway/config".source = ../config/sway/config;
}
