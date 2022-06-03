{ pkgs, lib, neovim-nightly, ... }: {

  # Darwin is my main OS. 
  # Therefore, I will not use {xdg.configFile."nvim/init.lua".source} to manage my nvim config  <-- Everytime I make a minor change, I have to rebuild my OS
  # Insteed, I decide to use the conventional and undeterministic way <-- Simple symbolic link

  home.activation.linkNeovim = lib.hm.dag.entryAfter [ "writeBoundary" ]
    ''
      ln -sfn $HOME/flake/config/nvim  $HOME/.config/nvim
    '';


  home.packages = with pkgs;  [

    (neovim-unwrapped.overrideAttrs (oldAttrs: {
      version = "nightly";
      src = neovim-nightly;
    }))

    #Compile Tree-Sitter parsers
    # default clang

    #LSP Server
    rnix-lsp #rnix-lsp
    sumneko-lua-language-server #lua-language-server
    nodePackages.bash-language-server #bash
    nodePackages.pyright #python
    rust-analyzer #rust

    nodePackages.typescript
    nodePackages.typescript-language-server #Typescript

    cargo #Rust
    rustc
    nodejs # JavaScript

    # Telescope
    fd
    ripgrep
  ];
}
