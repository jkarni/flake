{ pkgs, lib, config, osConfig, ... }: {


  # https://github.com/azuwis/nix-config/commit/64a28173876aaf03f409691457e4f9500d868528
  # DO NOT USE nix-darwin to configure launchd  <-- many issues and strange behaviour

  # see details: os/darwin/brew.nix
 
  home.file.".config/skhd".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/skhd";

}
