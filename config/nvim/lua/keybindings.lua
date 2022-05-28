--I like Arrow Keys
--I am extremely uncomfortable with hjkl due to the games I played in my childhood


--https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- Deprecated: vim.api.nvim_set_keymap | default : noremap = false |(which is only for plugin recusive mapping)
-- New: vim.keymap.set | default : noremap = true |(No-recursive is for most of time)

local keymap = vim.keymap.set
local opts = { silent = true }
local M = {}

--Remap space as leader key
keymap({ 'n', 'v' }, '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Consistent with Ranger exit
-- ZQ Quit Without Save
-- ZZ Quit With Save
keymap("n", "Q", ":qa<CR>")

-- Reverse CTRL-O and CTRL_I, I prefer left is previous and right is next
keymap("n", "<C-o>", "<C-i>")
keymap("n", "<C-i>", "<C-o>")

--Better Line Movement
keymap({ 'n', 'v' }, "-", "_")
keymap({ 'n', 'v' }, "_", "-")
keymap({ 'n', 'v' }, "=", "$")

--Window Split
keymap("n", "<leader>v", ":vsp<CR>")
keymap("n", "<leader>h", ":sp<CR>")

--Window Close Focus
keymap("n", "<C-w>", "<C-w>c")

--Window Close Other
keymap("n", "<C-q>", "<C-w>o")

--Window Jump
keymap("n", "<C-Left>", "<C-w>h")
keymap("n", "<C-Down>", "<C-w>j")
keymap("n", "<C-Up>", "<C-w>k")
keymap("n", "<C-Right>", "<C-w>l")

-- Windows Resize
-- h 上下方向 +
-- j 上下方向 -
keymap("n", "<C-h>", ":resize +2<CR>")
keymap("n", "<C-j>", ":resize -2<CR>")
-- k 左右方向 +
-- l 左右方向 -
keymap("n", "<C-k>", ":vertical resize +2<CR>")
keymap("n", "<C-l>", ":vertical resize -2<CR>")


--Buffer in Window
keymap("n", "<A-Left>", ":bp<CR>", opts)
keymap("n", "<A-Right>", ":bn<CR>", opts)
--Buffer Close
keymap("n", "<A-w>", ":Bdelete!<CR>")

--Reverse Common Value
keymap("n", "<leader>r", ":ToggleAlternate<CR>")

--Show Dashboard
keymap("n", "<leader>a", ":Alpha<CR>")



-- Indent with Tab and Shift-Tab
keymap('v', '<Tab>', '>')
keymap('v', '<S-Tab>', '<')

-- ESC Terminal
keymap("t", "<Esc>", "<C-\\><C-n>")

-- Warpper Terminal
M.toggleTerm = "<leader>\\"

-- Telescope
-- Find File Base On Path
keymap("n", "<leader>p", ":Telescope find_files<CR>")
-- Find Code
keymap("n", "<leader>f", ":Telescope live_grep<CR>")


-- Vimtree
-- alt + b 键打开关闭tree [VScode]
keymap("n", "<A-b>", ":NvimTreeToggle<CR>", opts)

-- 列表快捷键
M.nvimTreeList = {
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

-- Clipboard
keymap("n", '<leader>d', ":Telescope neoclip<CR>", opts)

M.LSP_on_attach = function(_, bufnr)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostics window' })
  vim.keymap.set('n', '<leader>[', vim.diagnostic.goto_prev, { desc = 'diagnostic.goto_prev' })
  vim.keymap.set('n', '<leader>]', vim.diagnostic.goto_next, { desc = 'diagnostic.goto_next' })
  vim.keymap.set('n', '<leader>l', vim.diagnostic.setloclist, { desc = 'List all diagnostics' })
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = bufnr })
  -- .h
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr })
  -- .cpp
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
  -- Workflow gh, gd, gD
  -- <C-t> return :help jumplist taglist

  -- variable type
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = bufnr })
  -- function parameter
  vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { buffer = bufnr })
  -- class implement stuff
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr })
  -- find references/symbol
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr })
  -- rename symbol(lsp based! Not regex)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr })
  -- auto import sth
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
end

-- commandline
-- <C-p>,<C-n> is nvim-cmp plguin keymapping(not nvim build-in)
-- Therefore, we need recusive mapping
keymap("c", "<Up>", "<C-p>", { remap = true, silent = true })
keymap("c", "<Down>", "<C-n>", { remap = true, silent = true })


M.cmp = function(cmp)
  return {
    -- 上一个
    ["<Up>"] = cmp.mapping.select_prev_item(),
    -- 下一个
    ["<Down>"] = cmp.mapping.select_next_item(),
    -- 确认
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  }
end

--Only for show info, not for setting
M.comment = {
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



return M
