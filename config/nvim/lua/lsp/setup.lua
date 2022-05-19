local lspconfig = require("lspconfig")
local servers = require("lsp/servers")


for lsp, config in pairs(servers) do
  lspconfig[lsp].setup(config)
end
