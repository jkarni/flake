{ config, ... }: {
  services.shadowsocks = {
    enable = true;
    port = 6666;
    passwordFile = config.sops.secrets.shadowsocks-password.path;
    extraConfig = {
      nameserver = "1.1.1.1";
    };
  };
}
