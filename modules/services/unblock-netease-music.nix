{ pkgs
, lib
, config
, UnblockNeteaseMusic
, ...
}:
let
  cfg = config.services.unblock-netease-music;
in
{
  options = {
    services.unblock-netease-music.enable = lib.mkEnableOption "UnblockNeteaseMusic service";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs
      yt-dlp
    ];

    systemd.services."UnblockNeteaseMusic" = {
      description = "UnblockNeteaseMusic Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        PATH = pkgs.lib.mkForce "${pkgs.yt-dlp}/bin";
      };


      # wait fix https://github.com/UnblockNeteaseMusic/server/issues/775#issuecomment-1181323847
      # only use bilibili now
      serviceConfig = {
        Restart = "always";
        ExecStart = "${pkgs.nodejs}/bin/node  ${UnblockNeteaseMusic}/app.js -e https://music.163.com  -o bilibili";
      };
    };
  };
}
