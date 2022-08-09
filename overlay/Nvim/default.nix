{ neovim-nightly }: final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (finalAttrs: previousAttrs: {
    version = "master";
    src = neovim-nightly;
  });
}
