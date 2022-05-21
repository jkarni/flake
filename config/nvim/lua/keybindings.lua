--default noremap=true(no recusive mapping), for replace nvim-buildin commands
--https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

local opt = {
  noremap = true,
  silent = true,
}

local map = vim.api.nvim_set_keymap
local pluginKeys = {}

--Remap space as leader key
map("", "<Space>", "<Nop>", opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "Q", ":qa<CR>", opt)

--Window Split
map("n", "<C-v>", ":vsp<CR>", opt)
map("n", "<C-h>", ":sp<CR>", opt)
--Window Close
map("n", "<C-w>", "<C-w>c", opt)
--Window Jump
map("n", "<C-Left>", "<C-w>h", opt)
map("n", "<C-Down>", "<C-w>j", opt)
map("n", "<C-Up>", "<C-w>k", opt)
map("n", "<C-Right>", "<C-w>l", opt)


--Buffer Jump in Window
map("n", "<A-Left>", ":BufferLineCyclePrev<CR>", opt)
map("n", "<A-Right>", ":BufferLineCycleNext<CR>", opt)
--Buffer Close
map("n", "<A-w>", ":bdelete!<CR>", opt)


-- Windows Resize
-- 记不住了，摆烂，直接鼠标拖
-- map("n", "<C-Left>", ":vertical resize -2<CR>", opt)
-- map("n", "<C-Right>", ":vertical resize +2<CR>", opt)
-- map("n", "<C-Down>", ":resize +2<CR>", opt)
-- map("n", "<C-Up>", ":resize -2<CR>", opt)


-- Basic Terminal
--map("n", "<C-t>", ":belowright split |resize 10 |terminal<CR>i", opt)

-- ESC Terminal
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- Warpper Terminal
pluginKeys.toggleTerm = [[<C-\>]]

-- Telescope
-- Find File Base On Path
map("n", "<C-p>", ":Telescope find_files<CR>", opt)
-- Find Code
map("n", "<C-f>", ":Telescope live_grep<CR>", opt)



-- Vimtree
-- alt + b 键打开关闭tree [VScode]
map("n", "<A-b>", ":NvimTreeToggle<CR>", opt)

-- 列表快捷键
pluginKeys.nvimTreeList = {
  -- 打开文件或文件夹
  { key = { "<CR>" }, action = "edit" },
  -- 分屏打开文件
  { key = "v", action = "vsplit" },
  { key = "h", action = "split" },
  -- 显示隐藏文件
  { key = "i", action = "toggle_ignored" }, -- Ignore (node_modules)
  { key = ".", action = "toggle_dotfiles" }, -- Hide (dotfiles)
  -- 文件操作
  { key = "a", action = "create" },
  { key = "d", action = "remove" },
  { key = "r", action = "rename" },
  { key = "x", action = "cut" },
  { key = "c", action = "copy" },
  { key = "p", action = "paste" },
  { key = "o", action = "open" },
}




pluginKeys.mapLSP = function(mapbuf)
  -- rename
  mapbuf("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opt)
  -- code action
  mapbuf("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opt)
  -- go xx
  mapbuf("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opt)
  mapbuf("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
  mapbuf("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
  mapbuf("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opt)
  mapbuf("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opt)
  -- diagnostic
  mapbuf("n", "gp", "<cmd>lua vim.diagnostic.open_float()<CR>", opt)
  mapbuf("n", "gk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opt)
  mapbuf("n", "gj", "<cmd>lua vim.diagnostic.goto_next()<CR>", opt)
  mapbuf("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opt)
  -- 没用到
  -- mapbuf('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opt)
  -- mapbuf("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opt)
  -- mapbuf('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opt)
  -- mapbuf('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opt)
  -- mapbuf('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opt)
  -- mapbuf('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opt)
end

-- 命令行下cmp
-- <C-p>,<C-n> is cmp plguin keymapping(not nvim build-in)
-- Therefore, we need recusive mapping
map("c", "<Up>", "<C-p>", { noremap = false })
map("c", "<Down>", "<C-n>", { noremap = false })

pluginKeys.cmp = function(cmp)
  return {
    -- 上一个
    ["<Up>"] = cmp.mapping.select_prev_item(),
    -- 下一个
    ["<Down>"] = cmp.mapping.select_next_item(),
    -- 确认
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  }
end

pluginKeys.comment = {
  -- Normal 模式快捷键
  toggler = {
    line = "gcc", -- 行注释
  },
  -- Visual 模式
  opleader = {
    line = "gc",
    bock = "gb",
  },
}



return pluginKeys

