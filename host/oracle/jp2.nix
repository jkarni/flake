{ config
, pkgs
, ...
}: {
  imports = [
    ./default.nix
  ];

  services.rss-telegram.enable = true;

  virtualisation.oci-containers.containers = {
    #podman run -p 8080:8080 pan93412/unblock-netease-music-enhanced -e https://music.163.com -o ytdlp bilibili
    "unblocknetease" = {
      image = "pan93412/unblock-netease-music-enhanced";
      ports = [
        "8080:8080"
      ];
      entrypoint = [
         "node app.js -e https://music.163.com -o ytdlp bilibili"
      ];

    };
  };
}



