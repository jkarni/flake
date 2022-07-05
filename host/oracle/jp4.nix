{ config
, pkgs
, ...
}:
let
  domain = "${config.networking.hostName}.mlyxshi.com";
in
{
  imports = [
    ./default.nix
  ];

  environment.systemPackages = with pkgs; [
    qbittorrent-nox
  ];

  # services.nginx.enable = true;
  # services.nginx.virtualHosts.${domain} = {
  #   root = "/var/lib/qbittorrent-nox/qBittorrent/downloads";
  #   locations."/" = {
  #     extraConfig = ''
  #       autoindex on;
  #       autoindex_exact_size on;
  #       autoindex_localtime on;
  #     '';
  #   };
  # };

  services.traefik.dynamicConfigOptions.http = {
    middlewares.qbittorrent.stripprefix.prefixes = "/qbittorrent";
    routers.qbittorrent = {
      middlewares = [ "qbittorrent" ];
      rule = "Host(`${domain}`) && PathPrefix(`/qbittorrent/`)";
      service = "qbittorrent";
    };
    services.qbittorrent.loadBalancer.servers = [{ url = "http://127.0.0.1:8080"; }];
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
