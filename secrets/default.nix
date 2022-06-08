{ config, lib, ... }: {
  sops.defaultSopsFile = ./key.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.secrets.hashedPassword = { };

  sops.secrets.ssh-private-key = { }// lib.optionalAttrs config.users.users.dominic { owner = "dominic"; };

  sops.secrets.shadowsocks-password = { };
}

