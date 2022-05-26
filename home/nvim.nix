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
            tree-sitter-markdown
          ]
        )
      )


    ];


    extraPackages = with pkgs; [
      cargo #Rust
      clang #C,C++
      clang-tools #C,C++
      nodejs # LSP Installer

      # Telescope
      fd
      ripgrep
    ];



    # homemanager current not support init.lua 
    # workaround
    # add extraConfig to  ~/.config/nvim/init.vim
    extraConfig = "
      lua require('options')
      lua require('plugins')
      lua require('colorscheme')
      lua require('keybindings')
      lua require('autocmds')
 
 
      lua require('lsp')
      lua require('lsp.ui')
      lua require('lsp.cmp')

      lua require('plugin-config.bufferline')
      lua require('plugin-config.feline')
      lua require('plugin-config.nvim-tree')
      lua require('plugin-config.telescope')
      lua require('plugin-config.fidget')
      lua require('plugin-config.alpha')
      lua require('plugin-config.project')
      lua require('plugin-config.nvim-treesitter')
      lua require('plugin-config.indent-blankline')
      lua require('plugin-config.autopair')
      lua require('plugin-config.modes')
      lua require('plugin-config.comment')
      lua require('plugin-config.gitsigns')
      lua require('plugin-config.toggleterm')
      lua require('plugin-config.whichkey')
      lua require('plugin-config.gps')
      lua require('plugin-config.autosession')
      lua require('plugin-config.reverse')


      lua require('plugin-config.colorizer')    
   ";


  };


}
