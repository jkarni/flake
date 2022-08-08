{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.services.unblock-netease-music;
in
{
  options = {
    services.unblock-netease-music.enable = lib.mkEnableOption "unblock-netease-music service";
  };

  config = lib.mkIf cfg.enable {
    # podman run -p 8080:8080 pan93412/unblock-netease-music-enhanced -e https://music.163.com -o ytdlp bilibili
    # can not use oci-containers directly, virtualisation.oci-containers.containers."xx".cmd will parse to "-e https://music.163.com" "-o ytdlp bilibili", UnblockNeteaseserver do not support quotation marks.

    systemd.services.unblock-netease-music = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStartPre = "${pkgs.podman}/bin/podman ps -al|grep unblock-netease-music && ${pkgs.podman}/bin/podman  rm -f unblock-netease-music";
        ExecStart = "${pkgs.podman}/bin/podman run --rm --name='unblock-netease-music' -p 8899:8080 pan93412/unblock-netease-music-enhanced -e https://music.163.com -o ytdlp bilibili";
      };
    };

    system.activationScripts.SyncNeteaseDNS = lib.stringAfter [ "var" ] ''
      RED='\033[0;31m'
      NOCOLOR='\033[0m'

      if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
        echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
        echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
      else
        ${pkgs.cloudflare-dns-sync} netease.mlyxshi.com
      fi
    '';

  };
}
