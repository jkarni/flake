{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./default.nix
  ];

  environment.systemPackages = with pkgs; [
    cachix
  ];
}
