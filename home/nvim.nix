{ pkgs, ... }: {

  xdg.configFile."nvim/lua".source = ../config/nvim/lua;

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [

      nvim-web-devicons
      plenary-nvim

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
            # tree-sitter-nix
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
      nodePackages.vscode-json-languageserver #JSON
      nodePackages.typescript-language-server #Tpyescript

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
      
      lua require('lsp')
      lua require('lsp/ui')
      lua require('lsp/cmp')
      
   ";
  };





}
