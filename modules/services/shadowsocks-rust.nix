{ pkgs, lib, config, ... }:
let
  cfg = config.packages.shadowsocks-rust;
in
{

  options = {
    env.desktop.enable = lib.mkEnableOption "shadowsocks-rust service";
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
