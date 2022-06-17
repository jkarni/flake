{
  nixpkgs.overlays = [
    (final: prev: {
      firefox-darwin = prev.callPackage ../pkgs/firefox-darwin { };
    })
  ];
}
