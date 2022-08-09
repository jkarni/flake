{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;

  system.activationScripts.SyncDNS = lib.stringAfter [ "var" ] ''
    RED='\033[0;31m'
    NOCOLOR='\033[0m'

    if [ ! -f ${config.sops.secrets.cloudflare-dns-token.path} ]; then
      echo -e "$RED Sops-nix Known Limitations: https://github.com/Mic92/sops-nix#using-secrets-at-evaluation-time $NOCOLOR"
      echo -e "$RED Please switch system again to use sops secrets and sync DNS $NOCOLOR"
    else
      ${pkgs.cloudflare-dns-sync} change.${config.networking.domain}
      ${pkgs.cloudflare-dns-sync} kms.${config.networking.domain}
    fi
  '';

  # ChangeDetectionIO
  virtualisation.oci-containers.containers = {
    # Local Port 3000
    "playwright-chrome" = {
      image = "browserless/chrome";
      ports = [
        "3000:3000"
      ];
    };

    # Port: 5000
    "change-detection-io" = {
      image = "dgtlmoon/changedetection.io";
      volumes = [ "datastore-volume:/datastore" ];
      environment = {
        PLAYWRIGHT_DRIVER_URL = "ws://localhost:3000/";
      };
      extraOptions = [
        "--network=host"
      ];
    };

    # Port 1688
    "kms-server" = {
      image = "mikolatero/vlmcsd";
      extraOptions = [
        "--network=host"
      ];
    };
  };
}

