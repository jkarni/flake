 {pkgs, ... }@args: {
  xdg.configFile."nvim".source = ../config/nvim/;

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
