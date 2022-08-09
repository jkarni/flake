let
  nixpkgs = import <nixpkgs> { };
  #flake = builtins.getFlake (toString ./.);
in
{ }
// builtins
// nixpkgs
// nixpkgs.lib
