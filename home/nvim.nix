{ pkgs, ... }@args: {

  xdg.configFile."nvim/lua".source = ../config/nvim/lua;
  xdg.configFile."nvim/.luarc.json".source = ../config/nvim/.luarc.json;

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [


      (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
        name = "modes-nvim";
        src = args.${name};
      })

      (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
        name = "nvim-lsp-installer";
        src = args.${name};
      })

      plenary-nvim
      nvim-web-devicons

      tokyonight-nvim
      bufferline-nvim
      nvim-tree-lua
      lualine-nvim
      lualine-lsp-progress
      dashboard-nvim
      telescope-nvim
      project-nvim
      nvim-autopairs
      indent-blankline-nvim

      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      vim-vsnip

      # Some tree-sitter language parsers are outdated or buggy in Nixpkg
      # Therefore, I prefer install by treesitter.setup({  ensure_installed ={"nix"} })
      # config/nvim/lua/plugin-config/nvim-treesitter.lua  
      (nvim-treesitter.withPlugins
        (
          plugins: with plugins; [
            tree-sitter-bash
            tree-sitter-json
            tree-sitter-typescript
            tree-sitter-c
            tree-sitter-cpp
            #tree-sitter-nix
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
      #fd
      #ripgrep

    ];



    # homemanager current not support init.lua 
    # workaround
    # add extraConfig to  ~/.config/nvim/init.vim
    extraConfig = "
      lua require('basic')
      lua require('colorscheme')  
      lua require('keybindings')      
      lua require('autocmds')

      lua require('plugin-config/bufferline')
      lua require('plugin-config/nvim-tree')      
      lua require('plugin-config/lualine')
      lua require('plugin-config/dashboard')
      lua require('plugin-config/project')
      lua require('plugin-config/nvim-treesitter')
      lua require('plugin-config/indent-blankline')
      lua require('plugin-config/autopair')
      lua require('plugin-config/modes')

      lua require('lsp')
      lua require('lsp/ui')
      lua require('lsp/cmp')
      
   ";


  };


}
