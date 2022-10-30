{ stdenvNoCC
, unzip
, fetchurl
,
}:
stdenvNoCC.mkDerivation rec {
  pname = "SF-Pro";
  version = "1.0";

  src = fetchurl {
    name = "SF-Pro";
    url = "https://github.com/mlyxshi/SF-Pro/releases/download/v1.0/release.zip";
    sha256 = "ebMwszbFxj3GT7wdZBbQWt5z0HMMG0/UhdN9tH19NuI=";
  };

  buildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    install -m444 -Dt  $out/share/fonts/truetype  *.ttf
    install -m444 -Dt  $out/share/fonts/opentype  *.otf
  '';

  meta = {
    description = "SF-Pro <-- Apple default font for English";
  };
}
