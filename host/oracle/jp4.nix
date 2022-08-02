{ config
, pkgs
, ...
}:
{
  imports = [
    ./default.nix
  ];

  services.qbittorrent-nox.enable = true;
  services.status-client.enable = true;

}
