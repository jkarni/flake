{ config, pkgs, ... }:
let
  domain = "jp4.mlyxshi.com";
in
{
  imports = [
    ./default.nix
  ];

  environment.systemPackages = with pkgs; [
    qbittorrent-nox
  ];


  services.nginx.enable = true;
  services.nginx.virtualHosts.${domain} = {
    root = "/var/lib/qbittorrent-nox/qBittorrent/downloads";
    locations."/" = {
      extraConfig = ''
          autoindex on;
        	autoindex_exact_size on;
        	autoindex_localtime on;
      '';
    };
  };


  # https://github.com/1sixth/flakes/blob/master/modules/qbittorrent-nox.nix

  systemd.services.qbittorrent-nox = {
    after = [ "local-fs.target" "network-online.target" "nss-lookup.target" ];
    description = "qBittorrent-nox service";
    serviceConfig = {
      PrivateTmp = false;
      User = "qbittorrent";
      # https://github.com/qbittorrent/qBittorrent/wiki/How-to-use-portable-mode
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=/var/lib/qbittorrent-nox --relative-fastresume";
      TimeoutStopSec = 1800;
      StateDirectory = "qbittorrent-nox";
    };
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
  };

  users = {
    groups.qbittorrent.gid = 1000;
    users.qbittorrent = {
      group = "qbittorrent";
      isSystemUser = true;
      uid = 1000;
    };
  };
}
