{ config, pkgs, lib, ...}: {

  sops.secrets.vaultwarden-domain = { };

  services.traefik.dynamicConfigOptions = {
    http.routers = {
      vaultwarden.rule = "Host({{ env `VAULTWARDEN_DOMAIN` }})";
      vaultwarden.service = "vaultwarden@docker";
    };
  };

  system.activationScripts.makeVaultwardenDir = lib.stringAfter [ "var" ] ''
    [ ! -d /var/lib/vaultwarden ] && mkdir -p /var/lib/vaultwarden
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