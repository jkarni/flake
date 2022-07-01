{ pkgs, lib, osConfig, config, ... }:
let
  # the special plugin which contains parsers  <-- need compile
  # use packer to manage other plugins 
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
      
      -- Add Treesitter Path
      vim.opt.runtimepath = vim.opt.runtimepath + "${TREESITTER}"
      
      -- Invoke Real Start
      require("start")
    '';
  };


  home.file.".config/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/nvim/lua";

  home.packages = with pkgs;  [

    neovim-unwrapped

    TREESITTER

    # Telescope
    fd
    ripgrep

  ] ++ lib.optionals osConfig.profile.developerMode.enable [ 

    rnix-lsp #rnix-lsp
    sumneko-lua-language-server #lua-language-server
    clang-tools # clangd  
    nodePackages.bash-language-server #bash
    nodePackages.pyright #python
    rust-analyzer #rust

    nodePackages.typescript #Typescript
    nodePackages.typescript-language-server 

    cargo #Rust
    rustc

    nodejs # JavaScript
  ];


}
