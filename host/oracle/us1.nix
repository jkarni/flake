{ config
, pkgs
, UnblockNeteaseMusic
, ...
}: {
  imports = [
    ./default.nix
  ];


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

    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.nodejs}/bin/node  ${UnblockNeteaseMusic}/server/app.js -e https://music.163.com  -o bilibili ytdlp";
    };
  };
}
