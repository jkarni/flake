{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./default.nix
  ];


  services = {
    unblock-netease-music.enable = true;
  };
}
