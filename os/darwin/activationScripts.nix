{ pkgs, ... }:
let
  path = "${pkgs.skhd}/bin/skhd";

  extraPolicies = import ../../config/firefox/app/policy.nix;
  wrapperPolicies = {
    policies =
      {
        DisableAppUpdate = true;
      }
      // extraPolicies;
  };
  policiesJson = pkgs.writeText "policies.json" (builtins.toJSON wrapperPolicies);
in
{
  # https://github.com/azuwis/nix-config/blob/master/darwin/skhd.nix
  # Add skhd to Settings->Privacy & Security->Accessibility        <-- launchd
  system.activationScripts.postActivation.text = ''
    ${pkgs.sqlite}/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
      'INSERT or REPLACE INTO access VALUES("kTCCServiceAccessibility","${path}",1,2,4,1,NULL,NULL,0,NULL,NULL,0,NULL);
      DELETE from access where client_type = 1 and client != "${path}" and client like "%/bin/skhd";'

    # add firefox policy
    [ ! -d "/Applications/Firefox.app/Contents/Resources/distribution" ] && mkdir "/Applications/Firefox.app/Contents/Resources/distribution"
    cat ${policiesJson} > "/Applications/Firefox.app/Contents/Resources/distribution/policies.json"


    #  show upgrade diff
    ${pkgs.nix}/bin/nix store --experimental-features nix-command diff-closures /run/current-system "$systemConfig"

  '';
}
