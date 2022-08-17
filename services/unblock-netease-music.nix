{ config, pkgs, lib, ... }: {

  sops.secrets.unblock-netease-music-env = { };

  systemd.services.podman-unblock-netease-music.preStart = lib.mkAfter ''
    ${pkgs.cloudflare-dns-sync} netease.${config.networking.domain}
  '';

  systemd.services.podman-unblock-netease-music.serviceConfig.EnvironmentFile = config.sops.secrets.unblock-netease-music-env.path;
  systemd.services.podman-unblock-netease-music.serviceConfig.ExecStart = lib.mkForce (pkgs.writeShellScript "podman-unblock-netease-music-start" ''
    set -e
    exec podman run \
      --rm \
      --name='unblock-netease-music' \
      --log-driver=journald \
      -p "$PORT:8080" \
      '--net=host' \
      pan93412/unblock-netease-music-enhanced --strict -e https://music.163.com -o ytdlp bilibili
  '');

}
