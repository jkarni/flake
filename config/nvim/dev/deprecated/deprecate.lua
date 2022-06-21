-- 最好自己管理lsp server，全局安装
-- lsp installer 与 NixOS不太兼容

local status, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status then
  vim.notify("LSP Installer Not Found")
  return
end


local uninstalled_servers = {}

for lsp ,T in pairs(require("lang-config.lsp.servers")) do
  local exeName=T.exeName
  if vim.fn.executable(exeName) == 0 then
    vim.notify("LSP ".. exeName.." Not Found")
    table.insert(uninstalled_servers,lsp)
  end
end

lsp_installer.setup {
  ensure_installed = uninstalled_servers,
}

-- brew install lua-language-server
-- npm install -g bash-language-server
-- npm install -g typescript-language-server typescript
-- npm install -g pyright
-- npm install -g vscode-json-languageserver
-- cargo .....