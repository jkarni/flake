{ pkgs, fetchurl, ... }: pkgs.appimageTools.wrapType2 {
  name = "kbct";
  src = fetchurl {
    url = "https://github.com/samvel1024/kbct/releases/download/v0.1.0/kbct-x86_64.AppImage";
    sha256 = "sm2kMkYJi3VkSRtlBr5qIr24i9FAKC6e/xQrwG1KST0=";
  };
  extraInstallCommands = ''
    mkdir -p $out/etc/kbct
    mkdir -p $out/share/applications
    echo "test" > $out/etc/kbct/mlyxtest.yml
    echo "test" > $out/share/applications/a.txt
  '';
}