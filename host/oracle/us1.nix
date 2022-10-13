{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443
    ../../services/nitter.nix
    ../../services/libreddit.nix
    ../../services/invidious.nix

    ../../services/podman-auto-update.nix
    ../../services/telegraf.nix
  ];

}
