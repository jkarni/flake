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


      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      vim-vsnip
    ];


    extraPackages = with pkgs; [
      #LSP Server
      rnix-lsp #Nix
      sumneko-lua-language-server #Lua
      nodePackages.bash-language-server #Bash
      nodePackages.pyright #Python

      rust-analyzer #Rust
      cargo #Rust

      clang #C,C++
      clang-tools #C,C++

      #LSP server need fix
      #Manually install by nvim-lsp-installer
      nodejs #nvim-lsp-installer Dependency

      #nodePackages.vscode-json-languageserver #JSON
      #nodePackages.typescript-language-server #Tpyescript

      #Optional Dependency
      #fd
      #ripgrep

    ];





    # homemanager current not support init.lua 
    # workaround
    # create ~/.config/nvim/init.vim
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
