{neovim-nightly,zsh-tab-title,...}:{
  nixpkgs.overlays = [
    (import ./AppleFont.nix)
    (import ./Zsh.nix {inherit zsh-tab-title;})
    (import ./Neovim.nix {inherit neovim-nightly;})
    (import ./Firefox.nix)
  ];
}
