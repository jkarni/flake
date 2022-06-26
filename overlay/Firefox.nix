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

  extraPolicies = import ../config/firefox/app/policy.nix;
  wrapperPolicies = {
    policies = {
      DisableAppUpdate = true;
    } // extraPolicies;
  };

  policiesJson = pkgs.writeText "policies.json" (builtins.toJSON wrapperPolicies);


  configPrefs = ../config/firefox/app/defaults/pref/config-prefs.js;
  configJs = ../config/firefox/app/config.js;
in
final: prev: {

  ################################################################################################
  # Linux stable
  firefox-tmp = prev.wrapFirefox prev.firefox-unwrapped {
    forceWayland = true;
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

  firefox-nightly-bin-tmp = prev.wrapFirefox prev.firefox-bin-unwrapped { };


  firefox-nightly-bin = final.firefox-nightly-bin-tmp.overrideAttrs (old: {
    pname = "firefox-bin-unwrapped";
    version = "nightly";

    src = prev.fetchurl {
      url = metaData.linux-url;
      sha256 = metaData.linux-sha256;
    };

    # installPhase = old.installPhase + ''
    #   rm "$out/lib/firefox/distribution/policies.json"
    #   cat ${policiesJson} > "$out/lib/firefox/distribution/policies.json"

    #   rm -rf "$out/lib/firefox/defaults/"
    #   mkdir -p  "$out/lib/firefox/defaults/pref/"
    #   cat ${configPrefs} > "$out/lib/firefox/defaults/pref/config-prefs.js"
    #   cat ${configJs} > "$out/lib/firefox/config.js"
    # '';

  });

  #firefox-nightly-bin = prev.wrapFirefox final.firefox-bin-unwrapped { };

  # firefox-nightly-bin = final.firefox-nightly-tmp.overrideAttrs (old: {
  #   installPhase = old.installPhase + ''
  #     rm "$out/lib/firefox/distribution/policies.json"
  #     cat ${policiesJson} > "$out/lib/firefox/distribution/policies.json"

  #     rm -rf "$out/lib/firefox/defaults/"
  #     mkdir -p  "$out/lib/firefox/defaults/pref/"
  #     cat ${configPrefs} > "$out/lib/firefox/defaults/pref/config-prefs.js"
  #     cat ${configJs} > "$out/lib/firefox/config.js"
  #   '';
  # });


  ################################################################################################
  # Darwin Nightly

  firefox-nightly-darwin = prev.callPackage ../pkgs/darwin/firefox { };
}
