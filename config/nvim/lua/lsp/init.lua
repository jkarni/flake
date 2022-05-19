local status, lspconfig = pcall(require, "lspconfig")
if not status then
  vim.notify("LSP Config Not Found")
  return
end

require("lsp/install")
require("lsp/setup")
