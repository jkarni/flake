{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443
    ../../services/nitter.nix
    ../../services/libreddit.nix
    ../../services/invidious.nix
  ];


  # systemd.services.podman-auto-update = {
  #   wants = [ "network-online.target" ];
  #   after = [ "network-online.target" ];
  #   serviceConfig = {
  #     Type="oneshot";
  #     ExecStart = "${pkgs.podman}/bin/podman auto-update";
  #     ExecStartPost = "${pkgs.podman}/bin/podman image prune -f";
  #   };
  #   wantedBy =[ "default.target" ];
  # };

  systemd.services.podman-auto-update = {
      serviceConfig = {
        ExecStart = [
          "" # override original
          "${podman} auto-update"
        ];
        ExecStartPost = [
          "" # override original
          "${podman} image prune -f"
        ];
      };
    };
}
