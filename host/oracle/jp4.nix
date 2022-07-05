{ config
, pkgs
, ...
}:

{
  imports = [
    ./default.nix
  ];

  # manually copy rclone config to /var/lib/qbittorrent-nox/rclone/rclone.conf  <-- GDtoken will refresh itself
  services.bt.enable =ture;

}
