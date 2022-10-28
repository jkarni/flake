{ stdenvNoCC
, fetchurl
, unzip
, buildFHSUserEnv
, writeShellScript
}:
let
  snell-static = stdenvNoCC.mkDerivation {
    pname = "snell-static";
    version = "4.0";

    src = fetchurl {
      url =
        if stdenvNoCC.hostPlatform == "x86_64-linux"
        then "https://dl.nssurge.com/snell/snell-server-v4.0.0-linux-amd64.zip"
        else "https://dl.nssurge.com/snell/snell-server-v4.0.0-linux-aarch64.zip";
      sha256 =
        if stdenvNoCC.hostPlatform == "x86_64-linux"
        then "jljuTqPC/7M6E/okiBaKz2xhykUH0nKoAYVdmwo0sLs="
        else "1ym2dlvvm7vjhjzkq5d3k8l1j42mz4q6plzj5m1xavindqmw6dqb";
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
      platforms = [ "x86_64-linux" "aarch64-linux" ];
    };
  };
in
buildFHSUserEnv {
  name = "snell";
  runScript = writeShellScript "snell-run" ''
    exec ${snell-static}/snell-server "$@" 
  '';
}
