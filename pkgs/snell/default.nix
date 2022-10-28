{ stdenvNoCC
, fetchurl
, unzip
}:
stdenvNoCC.mkDerivation{
  pname = "snell-static";
  version = "4.0";

  src = fetchurl {
    url = "https://dl.nssurge.com/snell/snell-server-v4.0.0-linux-amd64.zip";
    sha256 = "sha256-jljuTqPC/7M6E/okiBaKz2xhykUH0nKoAYVdmwo0sLs=";
  };

  buildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/usr/bin
    cp snell-server $out/usr/bin
  '';
}