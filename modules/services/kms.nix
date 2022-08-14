{ config, pkgs, lib, ... }: {

  system.activationScripts.SyncKMSDNS = lib.stringAfter [ "var" ] ''
    RED='\033[0;31m'
    NOCOLOR='\033[0m'

    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} kms.${config.networking.domain}
    fi
  '';

  virtualisation.oci-containers.containers = {
    "kms-server" = {
      image = "mikolatero/vlmcsd";
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.kms.rule=Host(`kms.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.kms.entrypoints=web"
      ];
    };
  };
}
