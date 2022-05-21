return {
  sumneko_lua = require("lang-config/lsp/setup/lua"),
  clangd = require("lang-config/lsp/setup/cpp"),
  bashls = require("lang-config/lsp/setup/bash"),
  tsserver = require("lang-config/lsp/setup/ts"),
  pyright = require("lang-config/lsp/setup/python"),
  jsonls = require("lang-config/lsp/setup/json"),
  rust_analyzer = require("lang-config/lsp/setup/rust"),
  rnix = require("lang-config/lsp/setup/nix")
}
