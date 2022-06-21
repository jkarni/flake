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

local status, navic = pcall(require, "nvim-navic")
if not status then
  vim.notify("navic Not Found")
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


--lua don't have continue, so we have to use strange 'repeat until' way to simulate it.
for server_name, lang_config in pairs(require("lang-config.lsp.servers")) do

  repeat
    -------------------------------------------------------------------------------
    --- continue part
    local exeName = lang_config.exeName
    if vim.fn.executable(exeName) == 0 then
      -- vim.notify("LSP ".. exeName.." Not Found")
      break
    end
    -------------------------------------------------------------------------------
    --- normal loop part
    local config = {
      on_attach = function(client, bufnr)
        -- navic.attach(client, bufnr)
        require("keybindings").LSP_on_attach(client, bufnr)
      end,
      capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    }
    config.settings = lang_config.config

    --lua extra config for nvim api
    if (server_name == "sumneko_lua") then
      lspconfig[server_name].setup(lua_dev.setup({ lspconfig = config }))
    else
      lspconfig[server_name].setup(config)
    end
    -------------------------------------------------------------------------------
  until true

end
