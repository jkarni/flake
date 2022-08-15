{ config, pkgs, lib, ...}: {

  system.activationScripts.SyncDNS = lib.stringAfter [ "var" ] ''
    RED='\033[0;31m'
    NOCOLOR='\033[0m'

    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} change.${config.networking.domain}
    fi
  '';

  system.activationScripts.makeChangeIODir = lib.stringAfter [ "var" ] ''
    [ ! -d /var/lib/changeio ] && mkdir -p /var/lib/changeio
  '';


  # ChangeDetectionIO
  virtualisation.oci-containers.containers = {
    # 3000
    "playwright-chrome" = {
      image = "browserless/chrome";
    };

    # 5000
    "change-detection-io" = {
      image = "dgtlmoon/changedetection.io";
      volumes = [ "/var/lib/changeio:/datastore" ];
      dependsOn = [ "playwright-chrome" ];
      environment = {
        PLAYWRIGHT_DRIVER_URL = "ws://playwright-chrome:3000/";
      };
      extraOptions = [
        #"--network=host"
        "--label"
        "traefik.enable=true"

        "--label"
        "traefik.http.routers.change.rule=Host(`change.${config.networking.domain}`)"
        "--label"
        "traefik.http.routers.change.entrypoints=web"
      ];
    };

  };
}