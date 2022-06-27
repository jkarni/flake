# nix-darwin only install application in "~/Application/Nix Apps" by default
# I prefer also link to system application path

# Home-Manager Firefox module manage profiles.ini by default <-- link to /nix/store , firefox doesn't have write permission
# Home-Manager Firefox module's approach works well in linux but not in darwin

# Reference: https://support.mozilla.org/en-US/kb/dedicated-profiles-firefox-installation
# Everytime after darwin firefox update, we need to set default profile   <-- about:profiles


{ pkgs, lib, ... }:

let

  firefoxConfigPath =
    if pkgs.stdenv.isLinux then
      ".mozilla/firefox"
    else
      "Library/Application Support/Firefox";


  firefoxProfile = ../config/firefox/profile/profiles.ini;


  linkFirefoxScript = lib.optionalString pkgs.stdenv.isDarwin ''
      ln -sfn "${pkgs.firefox}/Applications/Firefox Nightly.app"  "/Applications/Firefox Nightly.app"
    '';

  Firefox =
    if pkgs.stdenv.isLinux then
      pkgs.firefox-nightly-bin
    else
      pkgs.firefox-nightly-bin-darwin;
in

{

  home.packages = [
    Firefox
  ];


  home.file = {
    "${firefoxConfigPath}/default/chrome".source = ../config/firefox/profile/default/chrome;
  };


  home.activation = {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] linkFirefoxScript;
  };

}
