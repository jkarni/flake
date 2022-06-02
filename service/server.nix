{
  imports = [
    ./common.nix
    ./shadowsocks.nix
  ];

  boot.loader.systemd-boot.netbootxyz.enable = true;

}
