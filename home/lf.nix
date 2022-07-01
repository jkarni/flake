{ pkgs, config, osConfig, ... }:
let
  previewerWrapper = pkgs.writeShellScriptBin "previewerWrapper" (builtins.readFile ../config/lf/preview.sh);
  cleanerWrapper = pkgs.writeShellScriptBin "cleanerWrapper" (builtins.readFile ../config/lf/cleaner.sh);
in
{

  home.packages = with pkgs;  [
    lf
    
    # preview image 
    kitty
    previewerWrapper
    cleanerWrapper
  ];

  home.file.".config/lf/lfrc".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/lf/lfrc";

}
