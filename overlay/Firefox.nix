# https://nixos.org/manual/nixpkgs/stable/#build-wrapped-firefox-with-extensions-and-policies
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox/wrapper.nix
# https://nixos.wiki/wiki/Firefox
# https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#blob-path
{ lib, pkgs, ... }:

final: prev: {
  firefox =
    if lib.optionals pkgs.stdenv.isLinux
    then
      prev.wrapFirefox prev.firefox-unwrapped
        {
          forceWayland = true;
          # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
          extraPolicies = import ../config/firefox/policy.nix;
        }
    else prev.callPackage ../pkgs/firefox-darwin { };

}
