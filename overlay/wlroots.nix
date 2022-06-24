{ fetchFromGitLab }:

final: prev: {
  wlroots = prev.wlroots.overrideAttrs (finalAttrs: previousAttrs: rec {
    version = "master";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = version;
      sha256 = "O7o/25v07Da4Wt4lBq3CZ5kOObyx3Knp4zFnlvvwHmU=";
    };
  });
}
