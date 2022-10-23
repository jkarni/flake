{ pkgs, modulesPath, lib, config, ... }: {
  imports = [
    (modulesPath + "/profiles/headless.nix")
    (modulesPath + "/virtualisation/azure-agent.nix")
  ];

  virtualisation.azure.agent.enable = true;

  # hyper-v: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/hyperv-guest.nix
  virtualisation.hypervGuest.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;
  boot.growPartition = true;

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
    autoResize = true;
  };

  networking.usePredictableInterfaceNames = false;

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
  };

  systemd.network.wait-online.anyInterface = true;
  systemd.network.networks = {
    dhcp = {
      name = "eth0";
      DHCP = "yes";
    };
  };


  users.users.root = {
    hashedPassword = "$6$fwJZwHNLE640VkQd$SrYMjayP9fofIncuz3ehVLpfwGlpUj0NFZSssSy8GcIXIbDKI4JnrgfMZxSw5vxPkXkAEL/ktm3UZOyPMzA.p0";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe" ];
  };

  # sshd (server)
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  environment.systemPackages = [ pkgs.git ];

  system.build.azureImage = import "${modulesPath}/../lib/make-disk-image.nix" {
    inherit pkgs lib config;
    partitionTableType = "efi";
    postVM = ''
      ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=fixed,force_size -O vpc $diskImage $out/nixos.vhd
      rm $diskImage
    '';
    format = "raw";
  };
}
