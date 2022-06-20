{ stdenvNoCC, zsh-tab-title }:

stdenvNoCC.mkDerivation rec{
  pname = "zsh-tab-title";
  version = "master";

  src = zsh-tab-title;

  installPhase = ''
    mkdir $out
    cp $src/zsh-tab-title.plugin.zsh  $out
  '';

  meta = {
    description = "verbose window title for zsh";
  };
}
