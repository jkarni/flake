# https://nixos.org/manual/nixpkgs/stable/#build-wrapped-firefox-with-extensions-and-policies
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox/wrapper.nix
# https://nixos.wiki/wiki/Firefox
# https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#blob-path


# https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
# https://github.com/xiaoxiaoflood/firefox-scripts/tree/master/installation-folder
# https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig

{ pkgs }:
let
  metaData = builtins.fromJSON (builtins.readFile ../config/firefox/version.json);
in
final: prev: {

  ################################################################################################
  # Linux stable
  firefox-tmp = prev.wrapFirefox prev.firefox-unwrapped {
    forceWayland = true;
    extraPolicies = import ../config/firefox/app/policy.nix;
    extraPrefs = builtins.readFile ../config/firefox/app/config.js;
  };

  firefox-stable = final.firefox-tmp.overrideAttrs
    (old: {
      buildCommand = old.buildCommand + ''
        rm "$out/lib/firefox/distribution/policies.json"
        cat ${policiesJson} > "$out/lib/firefox/distribution/policies.json"

        rm -rf "$out/lib/firefox/defaults/"
        mkdir -p  "$out/lib/firefox/defaults/pref/"
        cat ${configPrefs} > "$out/lib/firefox/defaults/pref/config-prefs.js"
        cat ${configJs} > "$out/lib/firefox/config.js"
      '';
    });


  ################################################################################################
  # Linux nightly bin


  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox-bin/default.nix
  firefox-nightly-bin-unwrapped = (prev.firefox-bin-unwrapped.override {
    generated = {
      version = metaData.version;  # important, only overrideAttrs version is not enough
    };                             # overide from input
  }).overrideAttrs (old: {
    pname = "firefox-bin-unwrapped";
    src = prev.fetchurl {
      url = metaData.linux-url;
      sha256 = metaData.linux-sha256;
    };

  });

  firefox-nightly-bin = (prev.wrapFirefox final.firefox-nightly-bin-unwrapped {
    forceWayland = true;
    # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
    extraPolicies = import ../config/firefox/app/policy.nix;
    # https://github.com/xiaoxiaoflood/firefox-scripts/tree/master/installation-folder
    # https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig
    extraPrefs = builtins.readFile ../config/firefox/app/config.js;
  }).overrideAttrs
    (old: {
      buildCommand = old.buildCommand + ''
        echo 'pref("general.config.sandbox_enabled", false);' >> "$out/lib/"${libName}/defaults/pref/autoconfig.js"
      '';
    });

  ################################################################################################
  # Darwin Nightly

  firefox-nightly-darwin = prev.callPackage ../pkgs/darwin/firefox { };
}
