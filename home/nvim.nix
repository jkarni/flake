{ pkgs
, lib
, osConfig
, config
, ...
}:
let
  # the special plugin which contains parsers  <-- need compile
  # use packer to manage other plugins
  TREESITTER = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    plugins:
      with plugins; [
        tree-sitter-c
        tree-sitter-lua
        tree-sitter-nix
        tree-sitter-bash
        tree-sitter-json
        tree-sitter-typescript
        tree-sitter-cpp
        tree-sitter-rust
        tree-sitter-python
        tree-sitter-markdown
      ]
  );
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

  home.file.".config/nvim/lua".source =
    if osConfig.hm.nixConfigDir == ""
    then ../config/nvim/lua
    else config.lib.file.mkOutOfStoreSymlink "${osConfig.hm.nixConfigDir}/config/nvim/lua";




  home.packages = with pkgs;
    [
      neovim-unwrapped
      TREESITTER
      fd
      ripgrep
    ]
    ++ lib.optionals osConfig.profile.developerMode.enable [
      nil #nix-lsp
      sumneko-lua-language-server #lua-language-server
      # clang-tools # clangd
      # nodePackages.bash-language-server #bash
      # nodePackages.pyright #python
      # rust-analyzer #rust

      # nodePackages.typescript #Typescript
      # nodePackages.typescript-language-server

      # cargo #Rust
      # rustc

      nodejs # JavaScript
    ];
}
