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
    url = "https://dl.nssurge.com/snell/snell-server-v4.0.0-linux-aarch64.zip";
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

  meta = {
    description = "https://manual.nssurge.com/others/snell.html";
  };
};
in
buildFHSUserEnv {
  name = "snell";
  runScript = writeShellScript "snell-run" ''
    exec ${snell-static}/snell-server "$@" 
  '';
}