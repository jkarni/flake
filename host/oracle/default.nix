{ pkgs, homeStateVersion, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.root = import ../../home/server.nix;

  home-manager.extraSpecialArgs = { inherit homeStateVersion; };
  home-manager.sharedModules = [
    ../../modules/developerMode.nix

    {
      mode.developerMode.enable = false;
    }
  ];

  imports = [
    ./hardware.nix
    ../../nixos/server.nix
    ../../service/server.nix
    ../../secrets
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

