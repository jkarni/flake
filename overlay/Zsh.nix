{ zsh-tab-title, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      zsh-tab-title = prev.callPackage ../pkgs/zsh/zsh-tab-title { inherit zsh-tab-title; };
    })
  ];
}