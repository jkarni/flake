{ pkgs, lib, ... }: 

let 
  configPrefs = pkgs.writeText "config-prefs.js" (builtins.readFile ../config/firefox/app/defaults/pref/config-prefs.js);
  configJs = pkgs.writeText "config.js" (builtins.readFile ../config/firefox/app/config.js);

  firefoxConfigPath = if pkgs.stdenv.isLinux then
    ".mozilla/firefox"
  else 
    "Library/Application Support/Firefox";

  profilesPath = if pkgs.stdenv.isLinux  then firefoxConfigPath else "${firefoxConfigPath}";
in

{

  programs.firefox = {
    enable = true;
    # See details: overlay/Firefox.nix
    package =
      if pkgs.stdenv.isLinux
      then # Linux

        # delete original  lib/firefox/defaults
        # change to github:xiaoxiaoflood/firefox-scripts/
        pkgs.firefox.overrideAttrs
          (old: {
            buildCommand = old.buildCommand + ''
              rm -rf "$out/lib/firefox/defaults/"
              mkdir -p  "$out/lib/firefox/defaults/pref/"

              cat ${configPrefs} > "$out/lib/firefox/defaults/pref/config-prefs.js"
              cat ${configJs} > "$out/lib/firefox/config.js"
            '';
          })
      else # Darwin
        pkgs.firefox;
  };


    home.file = lib.optionalAttrs pkgs.stdenv.isDarwin{
      "${firefoxConfigPath}/profiles.ini".source=../config/firefox/profile/profiles.ini;

      "${profilesPath}/default/chrome".source=../config/firefox/profile/default/chrome;
    };

  # nix-darwin only install application in "~/Application/Nix Apps" by default
  # I prefer also link to system application path

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn "${pkgs.firefox}/Applications/Firefox Nightly.app"  "/Applications/Firefox Nightly.app"
    '';
  };


}
