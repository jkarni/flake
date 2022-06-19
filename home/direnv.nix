{ lib, config, ... }: {
  programs.direnv = lib.optionalAttrs config.home.developerMode.enable {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
