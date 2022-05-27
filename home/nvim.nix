# It is hard that gcc and clang exist simultaneously.
# Luckily, clangd does not need clang installed. <-- I prefer LLVM

# In general, nvim has 3 kinds of executable
# 1. nvim 
# 2. tree-sitter parsers
# 3. lsp servers
# Note: nvim plugin is vim/lua script(LuaJIT), so we can use Packer to manage plugins  <--I diskile using plugin from nixpkgs[outdate] 

# In other OS, We can simply use nvim's plugin to automate download/compile/install{2,3}
# NixOS needs patchelf, maybe? We can not simply download pre-build {2,3}
# All in all, This is the way that I can reuse my modern nvim config in different OS with tiny change. 

# I don't like homemanager's nvim module.
# It will create a init.vim file and mess up my config

# diff
# -- lsp_installer.setup {
# --   automatic_installation = true,
# -- }


{ pkgs, ... }: {

  # Do not include Packer's dir -- nvim/plugin -- need write permission
  xdg.configFile."nvim/init.lua".source = ../config/nvim/init.lua;
  xdg.configFile."nvim/lua".source = ../config/nvim/lua;


  home.packages = with pkgs;  [

    neovim

    #Compile Tree-Sitter parsers
    gcc

    #LSP Server
    rnix-lsp #rnix-lsp
    sumneko-lua-language-server #lua-language-server
    clang-tools # clangd  
    nodePackages.bash-language-server #bash
    nodePackages.pyright #python
    rust-analyzer #rust

    #JSON and TS LSP might be buggy or need extra configuration
    nodePackages.vscode-json-languageserver #JSON
    nodePackages.typescript-language-server #Tpyescript

    cargo #Rust
    nodejs # LSP Installer

    # Telescope
    fd
    ripgrep
  ];
}
