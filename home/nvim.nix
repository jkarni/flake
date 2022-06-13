{ pkgs, neovim-nightly, lib, ... }:
let

  TREESITTER = (pkgs.vimPlugins.nvim-treesitter.withPlugins (
    plugins: with plugins; [
      tree-sitter-bash
      tree-sitter-json
      tree-sitter-typescript
      tree-sitter-c
      tree-sitter-cpp
      tree-sitter-nix
      tree-sitter-lua
      tree-sitter-rust
      tree-sitter-python
      tree-sitter-markdown
    ]
  ));

in
{

  xdg.configFile = {
    "nvim/init.lua".text = ''
      -- Begin Stage: Cache and Accelerate
      require("plugin-config.impatient")
      
      -- Prepend Treesitter Path
      vim.opt.packpath = vim.opt.packpath ^ "${TREESITTER}"
      vim.opt.runtimepath = vim.opt.runtimepath ^ "${TREESITTER}"
      
      -- Invoke Real Start
      require("start")

    '';
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    "nvim/lua/".source = ../config/nvim/lua;
  };

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkNeovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/nvim/lua  $HOME/.config/nvim/lua
    '';
  };

  home.packages = with pkgs;  [

    (neovim-unwrapped.overrideAttrs
      (oa: {
        version = "master";
        src = neovim-nightly;
      })
    )

    TREESITTER

    #LSP Server
    rnix-lsp #rnix-lsp
    sumneko-lua-language-server #lua-language-server
    clang-tools # clangd  
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
