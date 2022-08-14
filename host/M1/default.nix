{
  imports = [
    ../../os/darwin
    ../../home/home-manager.nix
    ../../modules/services/ssh-config.nix
  ];

  home-manager.users.dominic = import ../../home/darwin.nix;
}
