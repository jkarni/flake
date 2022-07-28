{ config
, pkgs
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

    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.nodejs}/bin/node  /root/server/app.js -e "https://music.163.com"  -o ytdlp bilibili";
    };
  };
}
