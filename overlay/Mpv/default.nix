{ mpv-nightly }: final: prev: {
  mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (finalAttrs: previousAttrs: {
    version = "master";
    src = mpv-nightly;
  });
}
