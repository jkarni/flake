# https://nixos.org/manual/nixpkgs/stable/#build-wrapped-firefox-with-extensions-and-policies
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox/wrapper.nix
# https://nixos.wiki/wiki/Firefox
# https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#blob-path
{ lib, pkgs }:

final: prev: {
  firefox =
    if pkgs.stdenv.isLinux
    then # Linux
      prev.wrapFirefox prev.firefox-unwrapped
        {
          forceWayland = true;
          # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
          extraPolicies = import ../config/firefox/app/policy.nix;
        }
    else # Darwin
      prev.callPackage ../pkgs/darwin/firefox { };

}