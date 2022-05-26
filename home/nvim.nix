 {pkgs, ... }@args: {

  xdg.configFile."nvim/lua".source = ../config/nvim/lua;


  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [

      (nvim-treesitter.withPlugins
        (
          plugins: with plugins; [
            tree-sitter-nix
            tree-sitter-bash
            tree-sitter-json
            tree-sitter-typescript
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-lua
            tree-sitter-rust
            tree-sitter-python
          ]
        )
      )


    ];


    extraPackages = with pkgs; [
      rnix-lsp #Nix
      sumneko-lua-language-server #Lua
      nodePackages.bash-language-server #Bash
      nodePackages.pyright #Python

      rust-analyzer #Rust
      cargo #Rust

      clang #C,C++
      clang-tools #C,C++

      # Some LSP servers in Nixpkg are buggy  
      # nodePackages.vscode-json-languageserver #JSON
      # nodePackages.typescript-language-server #Tpyescript

      # install buggy LSP server by nvim-lsp-installer automaticallly
      # config/nvim/lua/lsp/install.lua

      #nvim-lsp-installer Dependency
      nodejs # LSP server in NPM

      #Optional Dependency

      # Telescope
      fd
      ripgrep

    ];



    # homemanager current not support init.lua 
    # workaround
    # add extraConfig to  ~/.config/nvim/init.vim
    extraConfig = "
      require("options")
      require("plugins")
      require("colorscheme")
      require("keybindings")
      require("autocmds")


      require("lsp")
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

      --After
      require("plugin-config.colorizer")

      
   ";


  };


}
