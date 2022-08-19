{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443

  ];


   virtualisation.oci-containers.containers = {

    "change-detection-io" = {
      image = "dgtlmoon/changedetection.io";
      volumes = [ "/var/lib/changeio:/datastore" ];
      extraOptions = [
        "--label"
        "traefik.enable=true"
      ];
    };

  };

  # systemd.services.podman-change-detection-io.preStart = lib.mkAfter ''
  #   mkdir -p /var/lib/changeio
  # '';

    systemd.services.podman-change-detection-io.serviceConfig.StateDirectory = "changeio";


}
