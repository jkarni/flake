{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./default.nix
  ];

  services.status-client.enable = true;
  services.status-server.enable = true;

  services.rss-telegram.enable = true;

}
