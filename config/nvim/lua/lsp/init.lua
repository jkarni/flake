local status, lspconfig = pcall(require, "lspconfig")
if not status then
	vim.notify("LSP Config Not Found")
	return
end

local servers = require("lsp/servers")


for lsp, config in pairs(servers) do
	lspconfig[lsp].setup(config)
end
