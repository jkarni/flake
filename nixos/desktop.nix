{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.enable = false;
    hostName = "nixos";
  };

  # Electron wayland
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  users.mutableUsers = false;
  security.sudo.wheelNeedsPassword = false;

  users.users = {
    dominic = {
      isNormalUser = true;
      description = "mlyxshi";
      hashedPassword = "$6$fwJZwHNLE640VkQd$SrYMjayP9fofIncuz3ehVLpfwGlpUj0NFZSssSy8GcIXIbDKI4JnrgfMZxSw5vxPkXkAEL/ktm3UZOyPMzA.p0";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpaY3LyCW4HHqbp4SA4tnA+1Bkgwrtro2s/DEsBcPDe" ];

    };
  };

}
