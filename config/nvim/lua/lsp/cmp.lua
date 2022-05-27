local status, cmp = pcall(require, "cmp")
if not status then
  vim.notify("Cmp Not Found")
  return
end

local status, lspconfig = pcall(require, "lspconfig")
if not status then
  vim.notify("LSP Config Not Found")
  return
end

local status, lua_dev = pcall(require, "lua-dev")
if not status then
  vim.notify("lua-dev Not Found")
  return
end

local status, luasnip = pcall(require, "luasnip")
if not status then
  vim.notify("luasnip Not Found")
  return
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources(
    {
      { name = "nvim_lsp" },
      { name = "luasnip" },
    },
    {
      { name = "buffer" },
      { name = "path" }
    }
  ),
  formatting = require('lsp.ui').formatting,
  mapping = require("keybindings").cmp(cmp),
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})



for server_name, lang_config in pairs(require("lang-config.lsp.servers")) do
  local config = {
    on_attach = require("keybindings").LSP_on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  }
  config.settings = lang_config
  --lua extra config for nvim api
  if (server_name == "sumneko_lua") then
    lspconfig[server_name].setup(lua_dev.setup({ lspconfig = config }))
  else
    lspconfig[server_name].setup(config)
  end
end