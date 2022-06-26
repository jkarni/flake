# https://nixos.org/manual/nixpkgs/stable/#build-wrapped-firefox-with-extensions-and-policies
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox/wrapper.nix
# https://nixos.wiki/wiki/Firefox
# https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#blob-path
{ stdenv }:
let
  metaData = builtins.fromJSON (builtins.readFile ../config/firefox/version.json);
  extraPrefs = ../config/firefox/app/config.js;
in
final: prev: {
  # Stable
  firefox =
    if stdenv.isLinux
    then
      prev.wrapFirefox prev.firefox-unwrapped
        {
          forceWayland = true;
          # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
          extraPolicies = import ../config/firefox/app/policy.nix;
          # https://github.com/xiaoxiaoflood/firefox-scripts/tree/master/installation-folder
          # https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig
          extraPrefs = builtins.readFile ../config/firefox/app/config.js;
        }
    else
      prev.callPackage ../pkgs/darwin/firefox { };

  firefox-nightly-bin = prev.wrapFirefox prev.firefox-bin-unwrapped.overrideAttrs
    (old: {
      pname = "firefox-bin";
      version = "nightly";

      src = prev.fetchurl {
        url = metaData.linux-url;
        sha256 = metaData.linux-sha256;
      };

    });

}
