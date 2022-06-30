{ stdenvNoCC, lib, fetchurl, writeText, undmg }:

let
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox/wrapper.nix
  extraPolicies = import ../../../config/firefox/app/policy.nix;

  wrapperPolicies = {
    policies = {
      DisableAppUpdate = true;
    } // extraPolicies;
  };

  policiesJson = writeText "policies.json" (builtins.toJSON wrapperPolicies);

  
  configPrefs = ../../../config/firefox/app/defaults/pref/config-prefs.js;
  configJs =  ../../../config/firefox/app/config.js;


  metaData = builtins.fromJSON (builtins.readFile ../../../config/firefox/version.json);
in

stdenvNoCC.mkDerivation rec {

  AppName = "Firefox Nightly.app";
  pname = "Firefox-Nightly";

  version = metaData.version;

  src = fetchurl {
    name = "firefox-nightly-${version}.dmg";
    inherit (metaData.darwin) url;
    inherit (metaData.darwin) sha256;
  };

  # https://github.com/NixOS/nixpkgs/pull/13636
  buildInputs = [ undmg ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    mv "${AppName}" $out/Applications

    mkdir "$out/Applications/${AppName}/Contents/Resources/distribution"
    cat ${policiesJson} > "$out/Applications/${AppName}/Contents/Resources/distribution/policies.json"

    cat ${configPrefs} > "$out/Applications/${AppName}/Contents/Resources/defaults/pref/config-prefs.js"
    cat ${configJs} > "$out/Applications/${AppName}/Contents/Resources/config.js"

  '';

  meta = {
    description = "Mozilla Firefox Nightly, (Darwin binary package)";
  };
}
