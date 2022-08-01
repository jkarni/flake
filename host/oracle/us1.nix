{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./default.nix
  ];

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  services = {
    unblock-netease-music.enable = true;
  };
}
