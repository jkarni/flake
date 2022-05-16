{
  config,
  lib,
  pkgs,
  ...
}: {


  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.sessionPackages = [ pkgs.gnome.gnome-session.sessions ];

  
  services.gnome3.gnome-remote-desktop.enable = true;

  services.gnome.gnome-keyring.enable = true;

}
