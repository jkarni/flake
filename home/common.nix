{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./zsh.nix
    ./nvim/nvim.nix
    ./nnn.nix
  ];
}
