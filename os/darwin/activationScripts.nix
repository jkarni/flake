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

  system.activationScripts.postActivation.text = ''
    # add firefox(homebrew) policy
    [ ! -d "/Applications/Firefox.app/Contents/Resources/distribution" ] && mkdir "/Applications/Firefox.app/Contents/Resources/distribution"
    cat ${policiesJson} > "/Applications/Firefox.app/Contents/Resources/distribution/policies.json"

    #  show upgrade diff
    ${pkgs.nix}/bin/nix store  diff-closures /run/current-system "$systemConfig"
  '';
}
