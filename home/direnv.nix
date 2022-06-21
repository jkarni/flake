{ lib, osConfig, ... }: {
  programs.direnv = lib.optionalAttrs osConfig.profile.developerMode.enable {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
