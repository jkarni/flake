{ config
, pkgs
, ...
}:

{
  imports = [
    ./default.nix
  ];

  # manually copy rclone config to /var/lib/qbittorrent-nox/rclone/rclone.conf  <-- GDtoken will refresh itself
  # TODO: impermanence + restic 
  services.bt.enable = true;

}
