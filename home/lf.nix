{ pkgs
, config
, osConfig
, ...
}:
let
  previewerWrapper = pkgs.writeShellScriptBin "previewerWrapper" (builtins.readFile ../config/lf/preview.sh);
  cleanerWrapper = pkgs.writeShellScriptBin "cleanerWrapper" (builtins.readFile ../config/lf/cleaner.sh);
in
{
  home.packages = with pkgs; [
    lf

    # preview image
    previewerWrapper
    cleanerWrapper
  ];


  home.file.".config/lf/lfrc".source =     
  if ${osConfig.hm.nixConfigDir} == ""
    then ../config/lf/lfrc
    else config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/lf/lfrc";
}
