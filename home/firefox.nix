{ pkgs, lib, ... }:

let

  firefoxConfigPath =
    if pkgs.stdenv.isLinux then
      ".mozilla/firefox"
    else
      "Library/Application Support/Firefox";

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
    #  https://support.mozilla.org/en-US/kb/understanding-depth-profile-installation
    #  Linux firefox wrapper by default set MOZ_LEGACY_PROFILES=1
    #  Under macOS, we need to set System-level environment variable MOZ_LEGACY_PROFILES=1 by launchctl setenv, See os/darwin/default.nix
    "${firefoxConfigPath}/profiles.ini".source = ../config/firefox/profile/profiles.ini;
    "${firefoxConfigPath}/default/chrome".source = ../config/firefox/profile/default/chrome;
  };


  # we need alias to /Applications so that Raycast/Spotlight can work
  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn "${pkgs.firefox-nightly-bin-darwin}/Applications/Firefox Nightly.app"  "/Applications/Firefox Nightly.app"
    '';
  };

}
