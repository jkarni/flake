{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs;  [
    gnome.gnome-control-center
    gnome.gnome-terminal
    baobab
    vscode-fhs
    mpv
    firefox-wayland

  ];


}
