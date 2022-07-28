# https://nixos.org/manual/nixpkgs/stable/#build-wrapped-firefox-with-extensions-and-policies
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox/wrapper.nix
# https://nixos.wiki/wiki/Firefox
# https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#blob-path
# https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
# https://github.com/xiaoxiaoflood/firefox-scripts/tree/master/installation-folder
# https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig
let
  metaData = builtins.fromJSON (builtins.readFile ../../config/firefox/version.json);
in
final: prev: {
  ################################################################################################
  # Linux

  firefox-linux = prev.wrapFirefox prev.firefox-unwrapped
    {
      forceWayland = true;
      extraPolicies = import ../../config/firefox/app/policy.nix;
    };

}
