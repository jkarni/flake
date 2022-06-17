{ fetchzip }:
fetchzip {
  url = "https://cdn.mlyxshi.com/PingFang.zip";
  sha256 = "uhfp7hHmRv/8VuqEzMZeNaGQCtYj3S56Q2ATBaIFmB0=";
  stripRoot=false;

  postFetch = ''
    install -m444 -Dt  $out/share/fonts/truetype  *.ttf
  '';

  meta = {
    description = "PingFang <-- Apple default font for Chinese";
  };
}