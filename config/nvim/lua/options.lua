--:help option_list 
--:help vim_diff.txt

vim.opt.mouse = "a"
vim.opt.number = true

vim.opt.splitbelow = true
vim.opt.splitright = true


vim.opt.writebackup = false
vim.opt.swapfile = false

-- RTFM :help tabstop
-- Why default is 8? http://web.mit.edu/ghudson/info/linus-coding-standard
-- Modern Indent is 2? https://google.github.io/styleguide/cppguide.html#Spaces_vs._Tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

--Use TreeSitter Indent

--Smart search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Global Statusline
vim.opt.laststatus = 3

--vim.opt.winbar ='%=%m %f'

vim.opt.helpheight =35

vim.opt.cursorline = true