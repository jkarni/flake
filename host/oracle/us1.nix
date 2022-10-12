{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443
    ../../services/nitter.nix
    ../../services/libreddit.nix
    ../../services/invidious.nix
  ];


  systemd.services.podman-auto-update = {
      serviceConfig = {
        ExecStart = "${pkgs.podman}/bin/podman auto-update";
        ExecStartPost = "${pkgs.podman}/bin/podman image prune -f";
      };
  };
}
