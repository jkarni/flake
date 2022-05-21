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

cmp.setup({
  -- 指定 snippet 引擎
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  -- 补全源
  sources = cmp.config.sources(
    {
      { name = "nvim_lsp" },
      { name = "vsnip" },
    },
    {
      { name = "buffer" },
      { name = "path" }
    }
  ),

  formatting = require('lsp/ui').formatting,
  mapping = require("keybindings").cmp(cmp),
})

-- / 查找模式使用 buffer 源
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- : 命令行模式中使用 path 和 cmdline 源.
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})


--SetUp LSP
for lsp, config in pairs(require("lang-config.lsp.servers")) do
  --lua-dev for Nvim Extra Setup
  if (lsp == "sumneko_lua") then
    lspconfig[lsp].setup(
      lua_dev.setup({ lspconfig = config })
    )
  else
    lspconfig[lsp].setup(config)
  end
end
