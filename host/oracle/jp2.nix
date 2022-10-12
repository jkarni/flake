{ pkgs, lib, config, ... }: {

  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443
    ../../services/rsshub.nix
    ../../services/miniflux.nix
    ../../services/vaultwarden.nix
  ];

  systemd.services.podman-auto-update-self = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman auto-update";
      ExecStartPost = "${pkgs.podman}/bin/podman image prune -f";
    };
  };

  systemd.timers.podman-auto-update-self = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

}
