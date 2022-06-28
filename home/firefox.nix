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
      pkgs.runCommand "firefox-0.0.0" { } "mkdir $out"; # declare firefox-darwin in environment.systemPackages instead <-- Raycast can launch

in

{

  home.packages = [
    Firefox
  ];


  home.file = {
    #  https://support.mozilla.org/en-US/kb/understanding-depth-profile-installation
    #  Linux firefox wrapper by default set MOZ_LEGACY_PROFILES=1
    #  Under macOS, we need to set System-level environment variables MOZ_LEGACY_PROFILES=1 by launchctl setenv, See os/darwin/default.nix
    "${firefoxConfigPath}/profiles.ini".source = ../config/firefox/profile/profiles.ini;
    "${firefoxConfigPath}/default/chrome".source = ../config/firefox/profile/default/chrome;
  };

}
