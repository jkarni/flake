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
    #  Under macOS, we need to set System-level environment variables MOZ_LEGACY_PROFILES=1 by launchctl setenv
    #  See home/zsh.nix
    "${firefoxConfigPath}/profiles.ini".source = ../config/firefox/profile/profiles.ini;
    "${firefoxConfigPath}/default/chrome".source = ../config/firefox/profile/default/chrome;
  };


  home.activation = {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.optionalString pkgs.stdenv.isDarwin ''
      ln -sfn "${pkgs.firefox-nightly-bin-darwin}/Applications/Firefox Nightly.app"  "/Applications/Firefox Nightly.app"
    '');
  };

}
