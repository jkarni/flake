{
  nixpkgs.overlays = [
    (final: prev: {
      kbct = prev.callPackage ../pkgs/kbct.nix { };
    })
  ];
}