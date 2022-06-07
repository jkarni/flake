{ lib, fetchFromGitHub }:
fetchFromGitHub{
  name = "sf-mono-liga-bin-2021-07-29";

  owner = "shaunsingh";
  repo = "SFMono-Nerd-Font-Ligaturized";
  rev = "83d887c6ec4989897fff19131a5de84766ecfdc9";
  sha256 = "sha256-hH5pLXD1NWqpKuQSqfDn50u2NPJmLlqOqllo2j3x2ag=";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    tar xf $downloadedFile -C $out/share/fonts/opentype
  '';

  meta = with lib; {
    description = "Ligaturized SF Mono";
    homepage = "https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}