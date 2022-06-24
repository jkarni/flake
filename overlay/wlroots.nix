{ wlroots-nightly }:

final: prev: {
  wlroots = prev.wlroots.overrideAttrs (finalAttrs: previousAttrs: {
    version = "master";
    src =  wlroots-nightly;
  });
}
