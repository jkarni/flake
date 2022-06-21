{ lib, pkgs, neovim-nightly, zsh-tab-title, ... }: {
  nixpkgs.overlays = [
    (import ./AppleFont.nix)
    (import ./Neovim.nix { inherit neovim-nightly; })
    (import ./Firefox.nix { inherit lib pkgs; })
  ];
}
