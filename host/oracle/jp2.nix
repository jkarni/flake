{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./default.nix
  ];

  services.rss-telegram.enable = true;
}
