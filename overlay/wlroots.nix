{ wlroots-nightly }:

final: prev: {
  wlroots = prev.wlroots.overrideAttrs (finalAttrs: previousAttrs: {
    version = "master";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = version;
      #sha256 = "sha256-MFR38UuB/wW7J9ODDUOfgTzKLse0SSMIRYTpEaEdRwM=";
    };
  });
}
