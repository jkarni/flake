{ pkgs, ... }@args: {

  imports = [
    ./hardware.nix
    ../../nixos/server.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.root = import ../../home;

  home-manager.extraSpecialArgs = { inherit (args) homeStateVersion  zsh-tab-title zsh-fast-syntax-highlighting zsh-you-should-use zsh-autosuggestions; };
  home-manager.sharedModules = [
    ../../modules/home
  ];


  # Workaround for fixing timeout issue
  # manually reboot once
  systemd.network.wait-online.anyInterface = true;

  systemd.network.networks = {
    dhcp = {
      name = "enp0s3";
      DHCP = "yes";
    };
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
    };
  };


}

