{ config
, pkgs
, ...
}:
{
  imports = [
    ./default.nix
  ];
  
  services.status-client.enable = true;
  services.qbittorrent-nox.enable = true;


}
