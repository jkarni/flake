{ pkgs, lib, config, osConfig, ... }: {

  home.packages = with pkgs; [
    skhd
  ];

  home.file.".config/skhd".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/skhd";


  # Manually run once!!!  
  # launchctl bootstrap  gui/${UID}  ~/Library/LaunchDaemons/org.nixos.skhd.plist 

  home.activation."CopySkhdLaunchDaemon" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cp -f ${pkgs.skhd}/Library/LaunchDaemons/org.nixos.skhd.plist $HOME/Library/LaunchDaemons/
  '';

}
