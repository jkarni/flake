{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./system.nix
    ./launchd.nix
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.nix-daemon.enable = true;

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowBroken = true;

  # System Level ZSH Enable
  programs.zsh.enable = true;

  programs.ssh = {
    knownHosts = {
      github = {
        hostNames = ["github.com"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };
  };

  # https://github.com/azuwis/nix-config/blob/master/darwin/skhd.nix
  # Add skhd to Settings->Privacy & Security->Accessibility        <-- launchd
  system.activationScripts.postActivation.text = let
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
  in ''
    ${pkgs.sqlite}/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
      'INSERT or REPLACE INTO access VALUES("kTCCServiceAccessibility","${path}",1,2,4,1,NULL,NULL,0,NULL,NULL,0,NULL);
      DELETE from access where client_type = 1 and client != "${path}" and client like "%/bin/skhd";'

    # add firefox policy
    [ ! -d "/Applications/Firefox.app/Contents/Resources/distribution" ] && mkdir "/Applications/Firefox.app/Contents/Resources/distribution"
    cat ${policiesJson} > "/Applications/Firefox.app/Contents/Resources/distribution/policies.json"


    #  show upgrade diff
    ${pkgs.nix}/bin/nix store --experimental-features nix-command diff-closures /run/current-system "$systemConfig"
    
  '';

  


      sops.defaultSopsFile = ../../modules/secrets/key.yaml;
    sops.age.keyFile = "/Users/dominic/Library/Application Support/sops/age/keys.txt";


    sops.secrets.restic-password = {
      owner= "dominic";
      group = "staff";
    };

}
