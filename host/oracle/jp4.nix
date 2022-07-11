{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./default.nix
  ];

  services.bt.enable = true;
}
