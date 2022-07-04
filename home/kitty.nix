{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  home.packages = [
    pkgs.kitty
  ];

  home.file.".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/kitty";
}
