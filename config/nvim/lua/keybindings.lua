--default noremap=true(no recusive mapping), for replace nvim-buildin commands
--https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

local opt = {
  noremap = true,
  silent = true,
}

local map = vim.api.nvim_set_keymap
local pluginKeys = {}

--Remap space as leader key
map("n", "<Space>", "<Nop>", opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "Q", ":qa<CR>", opt)

--Window Split
map("n", "<leader>v", ":vsp<CR>", opt)
map("n", "<leader>h", ":sp<CR>", opt)
--Window Close Focus
map("n", "<C-w>", "<C-w>c", opt)
--Window Close Other
map("n", "<C-o>", "<C-w>o", opt)
--Window Jump
map("n", "<C-Left>", "<C-w>h", opt)
map("n", "<C-Down>", "<C-w>j", opt)
map("n", "<C-Up>", "<C-w>k", opt)
map("n", "<C-Right>", "<C-w>l", opt)
-- Windows Resize
-- h 上下方向 +
-- j 上下方向 -
map("n", "<C-h>", ":resize +2<CR>", opt)
map("n", "<C-j>", ":resize -2<CR>", opt)
-- k 左右方向 +
-- l 左右方向 -
map("n", "<C-k>", ":vertical resize +2<CR>", opt)
map("n", "<C-l>", ":vertical resize -2<CR>", opt)

map("t", "<C-h>", ":resize +2<CR>", opt)
map("t", "<C-j>", ":resize -2<CR>", opt)
map("t", "<C-k>", ":vertical resize +2<CR>", opt)
map("t", "<C-l>", ":vertical resize -2<CR>", opt)


--Buffer Jump in Window
map("n", "<A-Left>", ":BufferLineCyclePrev<CR>", opt)
map("n", "<A-Right>", ":BufferLineCycleNext<CR>", opt)
--Buffer Close
map("n", "<A-w>", ":bdelete!<CR>", opt)


-- Basic Terminal
--map("n", "<C-t>", ":belowright split |resize 15 |terminal<CR>i", opt)

-- ESC Terminal
map("t", "<Esc>", "<C-\\><C-n>", opt)

-- Warpper Terminal
pluginKeys.toggleTerm = "<leader>\\"

-- Telescope
-- Find File Base On Path
map("n", "<leader>p", ":Telescope find_files<CR>", opt)
-- Find Code
map("n", "<leader>f", ":Telescope live_grep<CR>", opt)



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




pluginKeys.LSP_on_attach = function(client, bufnr)
  vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opt)
  vim.api.nvim_set_keymap('n', '<leader>[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opt)
  vim.api.nvim_set_keymap('n', '<leader>]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opt)
  vim.api.nvim_set_keymap('n', '<leader>l', '<cmd>lua vim.diagnostic.setloclist()<CR>', opt)

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opt)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opt)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opt)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opt)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opt)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opt)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opt)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opt)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opt)
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
