{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    shadowsocks-rust
  ];
  
  systemd.services.shadowsocks-rust = {
    description = "shadowsocks-rust Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
        Restart = "always";
        ExecStart = "${pkgs.shadowsocks-rust}/bin/ssserver -s 0.0.0.0 -p 6666 -m chacha20-ietf-poly1305 -k 12345 -u --fast-open";
    };

  };

}