{ pkgs, ... }: {
  
  environment.systemPackages = with pkgs; [
    shadowsocks-rust
  ];

  environment.etc = {
    "shadowsocks-rust/config.json"= {
      text = ''
      {
        "server": "0.0.0.0",
        "server_port": 6666,
        "method": "chacha20-ietf-poly1305",
        "password": "12345",
        "fast_open": true,
        "mode": "tcp_and_udp",
      }   
      '';
    };
  };
  
  systemd.services.shadowsocks-rust = {
    description = "shadowsocks-rust Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.shadowsocks-rust}/bin/ssserver -c /etc/shadowsocks-rust/config.json";
    };

  };

}