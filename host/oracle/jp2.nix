{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./default.nix
  ];

  services.rss-telegram.enable = true;

  services.invidious = {
    enable = true;
    port = 80;
  };
}
