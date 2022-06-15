{pkgs, ... }:

pkgs.appimageTools.wrapType2 {
  name = "kbct";
  src = pkgs.fetchurl {
    url = "https://github.com/samvel1024/kbct/releases/download/v0.1.0/kbct-x86_64.AppImage";
    #sha256 = "e76971bc65ab44285776e178b26f7b7872412ee0ec495ff204c13cb1fe091a35";
  };
}