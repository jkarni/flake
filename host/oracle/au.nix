{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443

  ];

  sops.secrets.miniflux-env = { };

  system.activationScripts.makeDownloadDir = pkgs.lib.stringAfter [ "var" ] ''
    cat ${config.sops.secrets.miniflux-env.path} > /tmp/test
  '';
}
