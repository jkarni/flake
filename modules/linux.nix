{ lib, pkgs, ... }: {
  imports = [
    ./hm
    
    ./profile/developerMode.nix
 
    ./profile/desktopEnv.nix

    ./secrets

    ./services/shadowsocks-rust.nix
    ./services/ssh-config.nix
  ];
}