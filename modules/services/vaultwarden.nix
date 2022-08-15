{ config, pkgs, lib, ...}: {

  sops.secrets.vaultwarden-domain = { };

  services.traefik.dynamicConfigOptions = {
    http.routers = {
      vaultwarden.rule = "Host(`{{ env VAULTWARDEN_DOMAIN }}`)";
      vaultwarden.service = "vaultwarden";
    };
  };

  system.activationScripts.makeVaultwardenDir = lib.stringAfter [ "var" ] ''
    [ ! -d /var/lib/vaultwarden ] && mkdir -p /var/lib/vaultwarden
  '';

  system.activationScripts.SyncVaultwardenDNS = lib.stringAfter [ "var" ] ''
    RED='\033[0;31m'
    NOCOLOR='\033[0m'

    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ] || [ ! -f ${config.sops.secrets.vaultwarden-domain.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} $(echo ${config.sops.secrets.vaultwarden-domain.path})
    fi
  '';

  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server";
      volumes = [ "/var/lib/vaultwarden:/data" ];
  
      extraOptions = [
        "--label"
        "traefik.enable=true"
      ];
    };

  };
}