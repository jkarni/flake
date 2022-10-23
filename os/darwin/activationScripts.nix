{ pkgs, ... }: {
  system.activationScripts.postActivation.text = ''
    #  show upgrade diff
    ${pkgs.nix}/bin/nix store  diff-closures /run/current-system "$systemConfig"
  '';
}
