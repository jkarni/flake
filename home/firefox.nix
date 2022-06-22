{ pkgs, lib, ... }:

let
  
  firefoxConfigPath =
    if pkgs.stdenv.isLinux then
      ".mozilla/firefox"
    else
      "Library/Application Support/Firefox";



  Firefox =
    if pkgs.stdenv.isLinux then # Linux
      # https://github.com/xiaoxiaoflood/firefox-scripts/tree/master/installation-folder
      # Also see:  overlay/Firefox.nix
      pkgs.firefox.overrideAttrs
        (old: {
          buildCommand = old.buildCommand + ''
            cat "pref("general.config.sandbox_enabled", false);" >> "$out/lib/firefox/defaults/pref/autoconfig.js"
          '';
        })
    else # Darwin
      pkgs.firefox;
in

{

  home.packages = [
    Firefox
  ];


  home.file = {
    "${firefoxConfigPath}/profiles.ini".source = ../config/firefox/profile/profiles.ini;
    "${firefoxConfigPath}/default/chrome".source = ../config/firefox/profile/default/chrome;
  };

  # nix-darwin only install application in "~/Application/Nix Apps" by default
  # I prefer also link to system application path
  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn "${pkgs.firefox}/Applications/Firefox Nightly.app"  "/Applications/Firefox Nightly.app"
    '';
  };


}
