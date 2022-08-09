{ stdenv
, fetchurl
, unzip
,
}:
stdenv.mkDerivation rec {
  pname = "ServerStatus-Server";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/cokemine/ServerStatus-Hotaru/archive/master.zip";
    sha256 = "+fGZZB1Jebl5BzP57abexXfwuW+sNivA41eN/y1t7+E=";
  };

  buildInputs = [ unzip ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  unpackPhase = ''
    unzip $src
  '';

  buildPhase = ''
    cd ./ServerStatus-Hotaru-master/server
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp sergate $out/bin
  '';

  meta = {
    description = "ServerStatus-Server";
  };
}
