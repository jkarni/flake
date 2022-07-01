{ pkgs, config, osConfig, ... }: {

  home.packages = with pkgs;  [
    lf
  ];

  home.file.".config/lf".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/lf";
}
