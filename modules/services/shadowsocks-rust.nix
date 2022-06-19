{ pkgs, lib, config, ... }:
let
  cfg = config.services.shadowsocks-rust;
in
{

  options = {
    services.shadowsocks-rust.enable = lib.mkEnableOption "shadowsocks-rust service";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      shadowsocks-rust
    ];

    systemd.services.shadowsocks-rust = {
      description = "shadowsocks-rust Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "always";
        ExecStart = "${pkgs.shadowsocks-rust}/bin/ssserver -c ${config.sops.secrets.shadowsocks-config.path}";
      };

    };


  };
}
