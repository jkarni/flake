{ config, lib, ... }: {
  sops.defaultSopsFile = ./key.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  
  sops.secrets.github-ci-token = { };
  sops.secrets.shadowsocks-config = { };
  sops.secrets.ssh-private-key = { } // lib.optionalAttrs config.profile.desktopEnv.enable { owner = "dominic"; };

}

