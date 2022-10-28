{ stdenvNoCC
, fetchurl
, unzip
, buildFHSUserEnv
, writeShellScript
}:
let 
snell-static=stdenvNoCC.mkDerivation{
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
    mkdir -p $out
    cp snell-server $out
  '';
};
in
buildFHSUserEnv {
  name = "snell";
  runScript = writeShellScript "snell-run" ''
    echo $0
    exec -a "''${0}" ${snell-static}/snell-server "$@" 
  '';
}