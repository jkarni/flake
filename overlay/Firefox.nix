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

  ################################################################################################
  # Linux stable
  firefox-tmp = prev.wrapFirefox prev.firefox-unwrapped {
    forceWayland = true;
    # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
    extraPolicies = import ../config/firefox/app/policy.nix;
    # https://github.com/xiaoxiaoflood/firefox-scripts/tree/master/installation-folder
    # https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig
    extraPrefs = builtins.readFile ../config/firefox/app/config.js;
  };

  firefox-stable = final.firefox-tmp.overrideAttrs
    (old: {
      buildCommand = old.buildCommand + ''
        echo 'pref("general.config.sandbox_enabled", false);' >> "$out/lib/firefox/defaults/pref/autoconfig.js"
      '';
    });


  ################################################################################################
  # Linux nightly bin

  firefox-bin-unwrapped = prev.firefox-bin-unwrapped.overrideAttrs ({
    pname = "firefox-bin-unwrapped";
    version = "nightly";

    src = prev.fetchurl {
      url = metaData.linux-url;
      sha256 = metaData.linux-sha256;
    };

  });

  firefox-nightly-bin = prev.wrapFirefox final.firefox-bin-unwrapped { };


  ################################################################################################
  # Darwin Nightly

  firefox-nightly-darwin = prev.callPackage ../pkgs/darwin/firefox { };
}
