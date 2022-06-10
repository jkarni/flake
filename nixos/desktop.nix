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

  users.mutableUsers = false;

  users.users = {
    dominic = {
      isNormalUser = true;
      description = "mlyxshi";
      hashedPassword = "$6$fwJZwHNLE640VkQd$SrYMjayP9fofIncuz3ehVLpfwGlpUj0NFZSssSy8GcIXIbDKI4JnrgfMZxSw5vxPkXkAEL/ktm3UZOyPMzA.p0";
      extraGroups = [ "wheel" ];
    };
  };

}