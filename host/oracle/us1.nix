{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.unblock-netease-music.enable = true;
}
