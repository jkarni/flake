{ config, pkgs, lib, ... }: {
  imports = [
    ./default.nix
    ../../services/traefik-cloudflare.nix #80,443

  ];

  sops.secrets.miniflux-db-env = { };

  system.activationScripts.makeDownloadDir = lib.stringAfter [ "setupSecrets" ] ''
    cat ${config.sops.secrets.miniflux-db-env.path} > /tmp/test
  '';
}
