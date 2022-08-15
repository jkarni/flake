{ config, pkgs, lib, ... }: {

  sops.secrets.vaultwarden-domain = { };
  sops.secrets.vaultwarden-env = { };

  system.activationScripts.makeVaultwardenDir = lib.stringAfter [ "var" ] ''
    [ ! -d /var/lib/vaultwarden ] && mkdir -p /var/lib/vaultwarden
  '';

  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server";
      volumes = [ "/var/lib/vaultwarden:/data" ];
    };

  };


  systemd.services.podman-vaultwarden.serviceConfig.EnvironmentFile = config.sops.secrets.vaultwarden-env.path;
  systemd.services.podman-vaultwarden.serviceConfig.ExecStart = lib.mkForce (pkgs.writeShellScript "podman-vaultwarden-start" ''
    set -e
    exec podman run \
      --rm \
      --name='vaultwarden' \
      --log-driver=journald \
      -v '/var/lib/vaultwarden:/data' \
      '--label' \
      'traefik.enable=true' \
      '--label' \
      "traefik.http.routers.websecure-vaultwarden.rule=Host(\`$DOMAIN\`)" \
      '--label' \
      'traefik.http.routers.websecure-vaultwarden.entrypoints=websecure' \
      vaultwarden/server
  '');

}
