{ config, pkgs, lib, ... }: {
  sops.secrets.restic-env = { };
  sops.secrets.restic-password = { };

  virtualisation.oci-containers.containers = {
    "vaultwarden" = {
      image = "vaultwarden/server";
      environment = {
        SIGNUPS_ALLOWED = "false";
        DOMAIN = "https://password.${config.networking.domain}"; #yubikey FIDO2 WebAuthn
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
        "traefik.http.routers.vaultwarden.entrypoints=websecure"

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
      ${pkgs.cloudflare-dns-sync} password.${config.networking.domain}
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
