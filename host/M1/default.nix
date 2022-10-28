{ pkgs, ... }: {
  imports = [
    ../../os/darwin
    ../../home/home-manager.nix
  ];

  home-manager.users.dominic = import ../../home/darwin.nix;

}
