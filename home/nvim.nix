{ pkgs, lib, ... }:
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

  xdg.configFile = lib.optionalAttrs pkgs.stdenv.isLinux {
    "nvim/lua".source = ../config/nvim/lua;
  };

  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkNeovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn $HOME/flake/config/nvim/lua  $HOME/.config/nvim/lua
    '';
  };

  home.packages = with pkgs;  [

    neovim-unwrapped

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



  xdg.configFile."nvim/init.lua".text = ''

    -- Append treesitter path
    vim.opt.packpath = vim.opt.packpath ^ "${TREESITTER}"
    vim.opt.runtimepath = vim.opt.runtimepath ^ "${TREESITTER}"

    -- Begin Stage
    require("plugin-config.impatient")

    require("options")
    require("plugins")
    require("colorscheme")
    require("autocmds")
    require("keybindings")


    require("lsp.ui")
    require("lsp.cmp")

    require("plugin-config.bufferline")
    require("plugin-config.feline")
    require("plugin-config.nvim-tree")
    require("plugin-config.telescope")
    require("plugin-config.fidget")
    require("plugin-config.alpha")
    require("plugin-config.project")
    require("plugin-config.nvim-treesitter")
    require("plugin-config.indent-blankline")
    require("plugin-config.autopair")
    require("plugin-config.modes")
    require("plugin-config.comment")
    require("plugin-config.gitsigns")
    require("plugin-config.toggleterm")
    require("plugin-config.whichkey")
    require("plugin-config.gps")
    require("plugin-config.autosession")
    require("plugin-config.reverse")
    require("plugin-config.surround")

    --Final Satge
    require("plugin-config.colorizer")
    
  '';




}
