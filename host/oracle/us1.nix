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

    environment = {
      PATH = pkgs.lib.mkForce "/run/wrappers/bin:/root/.nix-profile/bin:/etc/profiles/per-user/root/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
    };

    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.nodejs}/bin/node  /root/server/app.js -e https://music.163.com  -o bilibili ytdlp";
    };
  };
}
