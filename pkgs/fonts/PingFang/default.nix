{ lib, stdenvNoCC, unzip, fetchurl, ... }:

stdenvNoCC.mkDerivation rec{
  pname = "PingFang";
  version = "apple";

  src = fetchurl {
    url = "https://cdn.mlyxshi.com/PingFang.zip";
    sha256 = "CeKYLtOlNLSOAg5Rd8iC/kYrw0cEvdK+isQV7fst4yU=";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "PingFang <-- Apple default font for Chinese";
  };
}
