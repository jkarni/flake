{ pkgs, lib, config, osConfig, ... }:

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


  #  https://support.mozilla.org/en-US/kb/understanding-depth-profile-installation
  #  Linux firefox wrapper set MOZ_LEGACY_PROFILES=1 by default
  #  Under macOS, we need to set System-level environment variable MOZ_LEGACY_PROFILES=1 by launchctl setenv, See os/darwin/default.nix
  home.file = {
    "${firefoxConfigPath}/profiles.ini".source = config.lib.file.mkOutOfStoreSymlink ../config/firefox/profile/profiles.ini;
    "${firefoxConfigPath}/default/chrome".source = config.lib.file.mkOutOfStoreSymlink ../config/firefox/profile/default/chrome;
  };


  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn "${pkgs.firefox-nightly-bin-darwin}/Applications/Firefox Nightly.app"  "/Applications/Firefox Nightly.app"
    '';
  };

}
