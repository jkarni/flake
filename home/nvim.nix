{ pkgs, ... }@args: {

  # Do not include Packer's dir -- nvim/plugin
  xdg.configFile."nvim/init.lua".source = ../config/nvim/init.lua;
  xdg.configFile."nvim/lua".source = ../config/nvim/lua;

  home.packages = with pkgs;  [

    neovim
    sumneko-lua-language-server #Lua
    cargo #Rust
    clang #C,C++
    clang-tools #C,C++
    nodejs # LSP Installer

    # Telescope
    fd
    ripgrep
  ];
}
