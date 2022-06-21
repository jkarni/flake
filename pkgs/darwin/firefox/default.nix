{ stdenvNoCC, lib, fetchurl, writeText, undmg }:

let
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox/wrapper.nix
  extraPolicies = import ../../../config/firefox/policy.nix;
  wrapperPolicies = {
    policies = {
      DisableAppUpdate = true;
    } // extraPolicies;
  };

  policiesJson = writeText "policies.json" (builtins.toJSON wrapperPolicies);

  metaData = builtins.fromJSON (builtins.readFile ../../../config/firefox/darwin-version.json);
in

stdenvNoCC.mkDerivation rec {
  name = "firefox-app-${version}";

  pname = "Firefox";

  version = metaData.version;

  # To update run:
  # nix-prefetch-url --name 'firefox-app-latest.dmg' 'https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US'
  src = fetchurl {
    name = "firefox-app-${version}.dmg";
    url = metaData.url;
    sha256 = metaData.sha256;
  };

  # https://github.com/NixOS/nixpkgs/pull/13636
  buildInputs = [ undmg ];

  phases = [ "unpackPhase" "installPhase" ];

  # The dmg contains the app and a symlink, the default unpackPhase tries to cd into the only directory produced so it fails.

  # After running unpackPhase, the generic builder changes the current directory to the directory created by unpacking the sources. 
  # If there are multiple source directories, you should set sourceRoot to the name of the intended directory. 
  # Set sourceRoot = "."; if you use srcs and control the unpack phase yourself.
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    mv Firefox.app $out/Applications

    mkdir $out/Applications/Firefox.app/Contents/Resources/distribution
    cat ${policiesJson} > $out/Applications/Firefox.app/Contents/Resources/distribution/policies.json
  '';

  meta = {
    description = "Mozilla Firefox, Darwin, (binary package)";
  };
}
