{ stdenv
, fetchurl
, unzip
, pkgs
}:
let 

snell-static = stdenv.mkDerivation{
  pname = "snell-static";
  version = "4.0";

  src = fetchurl {
    url = "https://dl.nssurge.com/snell/snell-server-v4.0.0-linux-amd64.zip";
    sha256 = "";
  };

  buildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out
    cp snell-server $out
  '';


};
in
pkgs.buildFHSUserEnv {
  name = "snell";
  targetPkgs = pkgs: with pkgs;  [
      glibc
      snell-static
  ];
  runScript = "/snell-server";
}