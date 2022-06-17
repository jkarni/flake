{
  nixpkgs.overlays = [
    (final: prev: {
      firefox = prev.callPackage ../pkgs/firefox-darwin { };
    })
  ];
}
