{
  config,
  pkgs,
  ...
}:  {
  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;

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
      volumes = ["datastore-volume:/datastore"];
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
# Windows 10 LTSC 2021
# Install product key
#slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D
# Specifies KMS host
#slmgr.vbs /skms ovh.mlyxshi.com
# Prompts KMS activation attempt.
#slmgr.vbs /ato
# Display detailed license information.
#slmgr.vbs -dlv

