{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation {
  pname = "PingFang";
  version = "apple";

  src = fetchurl {
    url = "https://cdn.mlyxshi.com/PingFang.ttc";
    sha256 = "1f96r4by67hzqpr4p2wkrfnpj9b7x9qrmwns0312w2l2rnp2qajx";
  };

  dontUnpack = true;
  
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttc $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "fonts by Apple";
    homepage = "https://developer.apple.com/fonts/";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ mlyxshi ];
  };
}
