{ config, pkgs, lib, ... }: {

  sops.secrets.vaultwarden-domain = { };
  sops.secrets.vaultwarden-env = { };

  system.activationScripts.SyncVaultwardenDNS = lib.stringAfter [ "var" ] ''
    RED='\033[0;31m'
    NOCOLOR='\033[0m'
    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ] || [ ! -f ${config.sops.secrets.vaultwarden-domain.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} $(cat ${config.sops.secrets.vaultwarden-domain.path})
    fi
  '';


  system.activationScripts.makeVaultwardenDir = lib.stringAfter [ "var" ] ''
    [ ! -d /var/lib/vaultwarden ] && mkdir -p /var/lib/vaultwarden
  '';

  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server";
      volumes = [ "/var/lib/vaultwarden:/data" ];
    };
  };

  # strange way to hide actual domain
  systemd.services.podman-vaultwarden.serviceConfig.EnvironmentFile = config.sops.secrets.vaultwarden-env.path;
  systemd.services.podman-vaultwarden.serviceConfig.ExecStart = lib.mkForce (pkgs.writeShellScript "podman-vaultwarden-start" ''
    set -e
    exec podman run \
      --rm \
      --name='vaultwarden' \
      --log-driver=journald \
      -e 'SIGNUPS_ALLOWED'='false' \
      -e 'SENDS_ALLOWED'='false' \
      -e 'EMERGENCY_ACCESS_ALLOWED'='false' \
      -e 'WEBSOCKET_ENABLED'='true' \
      -v '/var/lib/vaultwarden:/data' \
      '--label' 'traefik.enable=true' \
      '--label' "traefik.http.routers.vaultwarden.rule=Host(\`$DOMAIN\`)" \
      '--label' 'traefik.http.routers.vaultwarden.entrypoints=websecure' \
      '--label' "traefik.http.services.vaultwarden@docker.loadbalancer.server.port=80"  \
      '--label' "traefik.http.routers.vaultwarden-ws.rule=Host(\`$DOMAIN\`) && Path(\`/notifications/hub\`)" \
      '--label' 'traefik.http.routers.vaultwarden-ws.entrypoints=websecure' \
      '--label' "traefik.http.services.vaultwarden-ws@docker.loadbalancer.server.port=3012"  \
      vaultwarden/server
  '');

}
