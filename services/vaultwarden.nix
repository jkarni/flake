{ config, pkgs, lib, ... }: {

  sops.secrets.restic-password = { };
  sops.secrets.rclone-config = { };

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
    ${pkgs.cloudflare-dns-sync} $(cat ${config.sops.secrets.vaultwarden-domain.path})
  '';

  services.restic.backups."vaultwarden-backup" = {
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    paths = [ "/var/lib/vaultwarden" ];
    repository = "rclone:r2:backup";
    timerConfig.OnCalendar = "06:00";
    pruneOpts = [ "--keep-last 2" ];
  };

}
