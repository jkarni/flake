{ pkgs, ... }: {
  system.activationScripts.postActivation.text = ''

    # Update Firefox Dock item, https://github.com/kcrawford/dockutil/releases
    /usr/local/bin/dockutil --remove Firefox --no-restart
    /usr/local/bin/dockutil --add ${pkgs.firefox-bin-darwin}/Applications/Firefox.app  --after 'Visual Studio Code'  --no-restart
    killall Dock
    
    #  show upgrade diff
    ${pkgs.nix}/bin/nix store  diff-closures /run/current-system "$systemConfig"
  '';
}
