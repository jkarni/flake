{pkgs, ...}:{

   imports = [
    ./common.nix
  ];

  environment.systemPackages = with pkgs; [
    gnome.gnome-control-center
    gnome.gnome-terminal
    baobab
    vscode-fhs
    mpv
    firefox-wayland
  ];




}
