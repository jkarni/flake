let
pkgs = import <nixpkgs> { };
#flake = builtins.getFlake (toString ./.);
in
{
}//builtins
//pkgs
//pkgs.lib