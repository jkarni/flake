{ fetchFromGitLab }:

final: prev: {
  wlroots = prev.wlroots.overrideAttrs (finalAttrs: previousAttrs: rec {
    version = "master";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = version;
      #sha256 = "";
    };
  });
}
