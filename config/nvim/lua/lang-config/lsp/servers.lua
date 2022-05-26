local pload = function(path)
  local status, lang_config = pcall(require, path)
  if not status then
    return {}
  end
  return lang_config
end

return {
  sumneko_lua = pload("lang-config/lsp/setup/lua"),
  clangd = pload("lang-config/lsp/setup/cpp"),
  bashls = pload("lang-config/lsp/setup/bash"),
  tsserver = pload("lang-config/lsp/setup/ts"),
  pyright = pload("lang-config/lsp/setup/python"),
  jsonls = pload("lang-config/lsp/setup/json"),
  rust_analyzer = pload("lang-config/lsp/setup/rust"),
  rnix = pload("lang-config/lsp/setup/nix")
}
