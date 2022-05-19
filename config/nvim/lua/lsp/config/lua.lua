--https://github.com/sumneko/lua-language-server/blob/master/changelog.md
-- Henceforth v3.2.3, Lua LSP server will parse .luarc.json as setting

return {
  on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    require('keybindings').mapLSP(buf_set_keymap)
  end,
}

