{ lib, stdenvNoCC, unzip, fetchurl, ... }:

stdenvNoCC.mkDerivation rec{
  pname = "SF-Pro";
  version = "apple";

  src = fetchurl {
    url = "https://cdn.mlyxshi.com/SF-Pro.zip";
    sha256 = "RrKsAY0UFMjnGmrDD/L8kLTxcTzCksvsaM8hJ+fwPFo=";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/fonts/opentype

    cp *.ttf $out/share/fonts/truetype
    cp *.otf $out/share/fonts/opentype
  '';

  meta = with lib; {
    description = "SF-Pro <-- Apple default font for English";
  };
}
