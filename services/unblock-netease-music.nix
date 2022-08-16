{ config, pkgs, lib, ... }: {

  virtualisation.oci-containers.containers = {
    #podman run -p 8080:8080 pan93412/unblock-netease-music-enhanced -e https://music.163.com -o ytdlp bilibili
    "unblock-netease-music" = {
      image = "pan93412/unblock-netease-music-enhanced";
      ports = [ "8080:8080" ];
      cmd = [ "-e" "https://music.163.com" "-o" "ytdlp" "bilibili" ];
      extraOptions = [
        "--net=host"
      ];
    };
  };

  systemd.services.podman-unblock-netease-music.preStart = lib.mkAfter ''
    ${pkgs.cloudflare-dns-sync} netease.${config.networking.domain}
  '';
}
