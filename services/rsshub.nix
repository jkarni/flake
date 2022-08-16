{ config, pkgs, lib, ... }: {

  # system.activationScripts.SyncRsshubDNS = lib.stringAfter [ "var" ] ''
  #   RED='\033[0;31m'
  #   NOCOLOR='\033[0m'

  #   if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
  #     echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
  #     echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
  #   else
  #     ${pkgs.cloudflare-dns-sync} rss.${config.networking.domain}
  #   fi
  # '';

  virtualisation.oci-containers.containers = {
    "rsshub" = {
      image = "diygod/rsshub";
      extraOptions = [
        "--label"
        "traefik.enable=true"
        "--label"
        "traefik.http.routers.websecure-rsshub.rule=Host(`rss1.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.websecure-rsshub.entrypoints=websecure"
      ];
    };
  };

  systemd.services.podman-rsshub.serviceConfig.ExecStartPre = lib.mkForce (pkgs.writeShellScript "podman-rsshub-pre-start" ''
    set -e
    podman rm -f rsshub || true
    
    RED='\033[0;31m'
    NOCOLOR='\033[0m'

    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} rss1.${config.networking.domain}
    fi
  '');

}
