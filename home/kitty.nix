{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  kitty =
    if pkgs.stdenv.isLinux
    then # Linux
      pkgs.kitty
    else # Darwin
      pkgs.runCommand "kitty-0.0.0" {} "mkdir $out";
in {
  home.packages = [kitty];

  home.file.".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/kitty";
}
