{ pkgs, ... }:
let
  extraPolicies = import ../../config/firefox/app/policy.nix;
  wrapperPolicies = {
    policies = {
      DisableAppUpdate = true;
    } // extraPolicies;
  };
  policiesJson = pkgs.writeText "policies.json" (builtins.toJSON wrapperPolicies);
in
{

  system.activationScripts.postActivation.text = ''
    # add firefox(homebrew) policy
    mkdir -p "/Applications/Firefox.app/Contents/Resources/distribution"
    cat ${policiesJson} > "/Applications/Firefox.app/Contents/Resources/distribution/policies.json"

    #  show upgrade diff
    ${pkgs.nix}/bin/nix store  diff-closures /run/current-system "$systemConfig"
  '';
}
