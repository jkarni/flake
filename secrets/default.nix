{ config, ... }: {
  sops.defaultSopsFile = ./key.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.secrets.hashedPassword = { };

  sops.secrets.ssh-private-key = if config.users.users ? dominic then { owner = "dominic"; } else { };

  sops.secrets.shadowsocks-password = { };
}

