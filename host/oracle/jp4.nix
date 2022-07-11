{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./default.nix
  ];

  services.qbittorrent-nox.enable = true;
}
