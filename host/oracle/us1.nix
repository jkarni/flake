{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];


  environment.systemPackages = [
    nodejs
    ytb-dlp
  ];

  # systemd.services."UnblockNeteaseMusic" = {
  #   description = "UnblockNeteaseMusic Daemon";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];

  #   serviceConfig = {
  #     Restart = "always";
  #     ExecStart = "${pkgs.shadowsocks-rust}/bin/ssserver -c ${config.sops.secrets.shadowsocks-config.path}";
  #   };
  # };
}
