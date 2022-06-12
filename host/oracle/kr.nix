{ config, pkgs, ... }: {

  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "kr.mlyxshi.com";
    port = 2333;
    addr = "127.0.0.1";
  };

  # nginx reverse proxy
  services.nginx.enable = true;
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
      # workaround https://community.grafana.com/t/after-update-to-8-3-5-origin-not-allowed-behind-proxy/60598/7
      extraConfig = ''
        proxy_set_header Host kr.mlyxshi.com;
      '';
    };
  };


  environment.systemPackages = with pkgs; [
    github-runner
  ];

  services.github-runner ={
    enable = true;
    name = "CI";
    url = "https://github.com/mlyxshi/flake";
    tokenFile= "${config.sops.secrets.github-ci-token.path}";
    extraLabels ="Linux-ARM64";

  };


}
