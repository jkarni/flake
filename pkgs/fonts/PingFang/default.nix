{ stdenvNoCC, unzip, fetchurl }:

stdenvNoCC.mkDerivation rec{
  pname = "PingFang";
  version = "apple";

  src = fetchurl {
    url = "https://github.com/mlyxshi/Ping-Fang/releases/download/v1.0/release.zip";
    sha256 = "ocSL4kFdnbcENGngPc57fq86zgEqFOCWOBspXFRmsqg=";
  };

  buildInputs = [ unzip ];

  unpackPhase =''
    unzip $src
  '';

  installPhase = ''
    install -m444 -Dt  $out/share/fonts/truetype  *.ttf
  '';

  meta = {
    description = "PingFang <-- Apple default font for Chinese";
  };
}