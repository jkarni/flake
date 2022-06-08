{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec{
  pname = "PingFang";
  version = "apple";

  src = fetchurl {
    url = "https://cdn.mlyxshi.com/PingFang.zip";
    sha256 = "1f96r4by67hzqpr4p2wkrfnpj9b7x9qrmwns0312w2l2rnp2qajx";
  };

  # nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "fonts by Apple";
    homepage = "https://developer.apple.com/fonts/";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ mlyxshi ];
  };
}
