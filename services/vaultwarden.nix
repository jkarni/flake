{ config, pkgs, lib, ... }: {
  sops.secrets.restic-env = { };
  sops.secrets.restic-password = { };

  sops.secrets.vaultwarden-domain = { };
  sops.secrets.vaultwarden-env = { };

  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server";
    };
  };

  # hide actual domain
  systemd.services.podman-vaultwarden.serviceConfig.EnvironmentFile = config.sops.secrets.vaultwarden-env.path;
  systemd.services.podman-vaultwarden.script = lib.mkForce ''
    exec podman run \
      --rm \
      --name='vaultwarden' \
      --log-driver=journald \
      -e 'SIGNUPS_ALLOWED'='false' \
      -e 'SENDS_ALLOWED'='false' \
      -e 'EMERGENCY_ACCESS_ALLOWED'='false' \
      -v '/var/lib/vaultwarden:/data' \
      '--label' 'traefik.enable=true' \
      '--label' "traefik.http.routers.vaultwarden.rule=Host(\`$DOMAIN\`)" \
      '--label' 'traefik.http.routers.vaultwarden.entrypoints=websecure' \
      '--label' 'traefik.http.routers.vaultwarden.service=vaultwarden' \
      '--label' 'traefik.http.services.vaultwarden.loadbalancer.server.port=80'  \
      vaultwarden/server
  '';

  systemd.services.podman-vaultwarden.preStart = lib.mkAfter ''
    mkdir -p /var/lib/vaultwarden
  '';

  system.activationScripts.cloudflare-dns-sync-vaultwarden = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} $(cat ${config.sops.secrets.vaultwarden-domain.path})
    '';
  };

  services.restic.backups."vaultwarden-backup" = {
    environmentFile = config.sops.secrets.restic-env.path;
    passwordFile = config.sops.secrets.restic-password.path;
    paths = [ "/var/lib/vaultwarden" ];
    timerConfig.OnCalendar = "06:00";
    pruneOpts = [ "--keep-last 2" ];
  };

}
