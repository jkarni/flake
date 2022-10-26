{ config, pkgs, lib, ... }: {
  sops.secrets.restic-env = { };
  sops.secrets.restic-password = { };

  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server";
      environment = {
        SIGNUPS_ALLOWED = "false"; # Disable signups
        DOMAIN = "https://password.${config.networking.domain}"; # Yubikey FIDO2 WebAuthn
        WEBSOCKET_ENABLED = "true"; # Websockets: real-time sync of data between server and clients (only browser and desktop Bitwarden clients)
      };
      volumes = [
        "/var/lib/vaultwarden:/data"
      ];
      extraOptions = [
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.vaultwarden.rule=Host(`password.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.vaultwarden.service=vaultwarden"
        "--label"
        "traefik.http.routers.vaultwarden.entrypoints=websecure"


        "--label"
        "traefik.http.routers.vaultwarden-websocket.rule=Host(`password.${config.networking.domain}`) && Path(`/notifications/hub`)"
        "--label"
        "traefik.http.routers.vaultwarden-websocket.service=vaultwarden-websocket"
        "--label"
        "traefik.http.routers.vaultwarden-websocket.entrypoints=websecure"


        "--label"
        "traefik.http.services.vaultwarden.loadbalancer.server.port=80"
        "--label"
        "traefik.http.services.vaultwarden-websocket.loadbalancer.server.port=3012"


        "--label"
        "io.containers.autoupdate=registry"
      ];
    };
  };

  systemd.services.podman-vaultwarden.environment.PODMAN_SYSTEMD_UNIT = "%n";

  systemd.services.podman-vaultwarden.serviceConfig.StateDirectory = "vaultwarden";

  system.activationScripts.cloudflare-dns-sync-vaultwarden = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync}/bin/cloudflare-dns-sync password.${config.networking.domain}
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
