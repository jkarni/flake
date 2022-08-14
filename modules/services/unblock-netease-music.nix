{ config, pkgs, lib, ...}:{

  system.activationScripts.SyncNeteaseDNS = lib.stringAfter [ "var" ] ''
    RED='\033[0;31m'
    NOCOLOR='\033[0m'
    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} netease.${config.networking.domain}
    fi
  '';


  virtualisation.oci-containers.containers = {
    #podman run -p 8080:8080 pan93412/unblock-netease-music-enhanced -e https://music.163.com -o ytdlp bilibili
    "unblock-netease-music" = {
      image = "pan93412/unblock-netease-music-enhanced";
      ports = [ "8080:8080" ];
      cmd = [ "-e" "https://music.163.com" "-o" "ytdlp" "bilibili" ];
      extraOptions = [
        "--net=host"
      ];
    };
  };
}
