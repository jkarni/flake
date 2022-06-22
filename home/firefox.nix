{ pkgs, lib, ... }: 

let 
  configPrefs = pkgs.writeText "config-prefs.js" (builtins.readFile ../config/firefox/app/defaults/pref/config-prefs.js);
  configJs = pkgs.writeText "config.js" (builtins.readFile ../config/firefox/app/config.js);
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


  programs.firefox.profiles = {
    default = {
      id = 0;
    };
    developer = {
      id = 1;
    };
  };

  # nix-darwin only install application in "~/Application/Nix Apps" by default
  # I prefer also link to system application path

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn "${pkgs.firefox}/Applications/Firefox Nightly.app"  "/Applications/Firefox Nightly.app"

      ln -sfn  $HOME/flake/config/firefox/profile/chrome   "$HOME/Library/Application Support/Firefox/Profiles/default/chrome" 
    '';
  };


  home.file = lib.optionalAttrs pkgs.stdenv.isLinux {
    ".mozilla/firefox/default/chrome".source = ../config/firefox/profile/chrome;
  };

}
