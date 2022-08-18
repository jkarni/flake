{ config, pkgs, lib, ... }: {

  sops.secrets.unblock-netease-music-env = { };

  virtualisation.oci-containers.containers = {
    "unblock-netease-music" = {
      image = "pan93412/unblock-netease-music-enhanced";
    };
  };

  systemd.services.podman-unblock-netease-music.serviceConfig.EnvironmentFile = config.sops.secrets.unblock-netease-music-env.path;
  systemd.services.podman-unblock-netease-music.script = lib.mkForce ''
    exec podman run \
      --rm \
      --name='unblock-netease-music' \
      --log-driver=journald \
      '--net=host' \
      pan93412/unblock-netease-music-enhanced -p $PORT --strict -e https://music.163.com -o ytdlp bilibili
  '';

  system.activationScripts.cloudflare-dns-sync-unblock-netease-music = {
    deps = [ "setupSecrets" ];
    text = ''
      ${pkgs.cloudflare-dns-sync} netease.${config.networking.domain}
    '';
  };

}
