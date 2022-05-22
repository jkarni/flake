return {
  on_attach = require("keybindings").LSP_on_attach,
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
