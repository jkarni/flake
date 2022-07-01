{ config, osConfig, ... }: {
  home.file.".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/wezterm";
}
