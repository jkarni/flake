{pkgs,...}:{

 xdg.configFile."nvim/lua".source=./lua;

programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
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
			
			(nvim-treesitter.withPlugins (
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
        ]
      ))

    ];
   

    extraPackages = with pkgs; [
     # gcc         
     # tree-sitter 
    ];





    # homemanager current not support lua.init
    # workround
    # create ~/.config/nvim/init.vim
    extraConfig = "
      lua require('basic')
      lua require('colorscheme')  
      lua require('keybindings')      


      lua require('plugin-config/bufferline')
      lua require('plugin-config/nvim-tree')      
      lua require('plugin-config/lualine')
      lua require('plugin-config/dashboard')
      lua require('plugin-config/project')
      lua require('plugin-config/nvim-treesitter')
      lua require('plugin-config/indent-blankline')
      lua require('plugin-config/autopair')


   ";
};







}
