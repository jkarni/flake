{ pkgs, lib, config, ... }: {
  sops.secrets.snell-config = { };

  environment.systemPackages = with pkgs; [
    snell
  ];

  systemd.services.snell = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Restart = "always";
      ExecStart = "snell -c ${config.sops.secrets.snell-config.path}";
    };
  };
}
