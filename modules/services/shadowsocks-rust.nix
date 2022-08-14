{ pkgs, lib, config, ... }: {
  sops.secrets.shadowsocks-config = { };

  environment.systemPackages = with pkgs; [
    shadowsocks-rust
  ];

  systemd.services.shadowsocks-rust = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.shadowsocks-rust}/bin/ssserver -c ${config.sops.secrets.shadowsocks-config.path}";
    };
  };
}
