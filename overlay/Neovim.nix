{ neovim-nightly, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (oldAttrs: {
        version = "master";
        src = neovim-nightly;
      });
    })
  ];
}

