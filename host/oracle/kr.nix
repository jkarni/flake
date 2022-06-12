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

  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/continuous-integration/github-runner/default.nix
  # https://www.reddit.com/r/NixOS/comments/cn6nt4/how_is_overrideattrs_different_from_override/
  # nodejs 12 is unsecure

  nixpkgs.config.allowInsecure = true;

  # environment.systemPackages = with pkgs; [
  #   github-runner 
  # ];



  services.github-runner = {
    enable = true;
    package = pkgs.github-runner.override { withNode12 = true; };
    url = "https://github.com/mlyxshi/flake";
    tokenFile = "${config.sops.secrets.github-ci-token.path}";
    extraLabels = [ "Linux-ARM64" ];

  };


}
