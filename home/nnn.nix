
{ config, lib, pkgs, self, ... }:

let
  inherit (self) inputs;
in
{

 programs.nnn = {
    enable = true;
    package = pkgs.nnn.override ({withNerdIcons = true;});
    plugins = {
      src = "${inputs.nnn-plugins}/plugins";
      mappings = {
        f = "finder";
	p = "preview-tui";
        v = "imgview";
      };
    };
  };



}
