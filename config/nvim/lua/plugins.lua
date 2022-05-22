local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  vim.notify("Pakcer Installing...")
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })

  -- https://github.com/wbthomason/packer.nvim/issues/750
  local rtp_addition = vim.fn.stdpath("data") .. "/site/pack/*/start/*"
  if not string.find(vim.o.runtimepath, rtp_addition) then
    vim.o.runtimepath = rtp_addition .. "," .. vim.o.runtimepath
  end
  vim.notify("Pakcer Install Success")
end

-- Use a protected call so we don't error out on first use
local status, packer = pcall(require, "packer")
if not status then
  vim.notify "Packer Not Found"
  return
end

packer.startup(function(use)
  --Installer
  use("wbthomason/packer.nvim")
  use("williamboman/nvim-lsp-installer")

  --Dependency
  use("kyazdani42/nvim-web-devicons")
  use("nvim-lua/plenary.nvim")
  --ColorScheme
  use("folke/tokyonight.nvim")

  --UI
  use("kyazdani42/nvim-tree.lua")
  use("akinsho/bufferline.nvim")
  use 'feline-nvim/feline.nvim'
  use 'famiu/bufdelete.nvim'
  use("j-hui/fidget.nvim")
  use("nvim-telescope/telescope.nvim")
  use "goolord/alpha-nvim"
  use("ahmedkhalf/project.nvim")
  use("lewis6991/gitsigns.nvim")
  use("akinsho/toggleterm.nvim")
  use("folke/which-key.nvim")

  --Tree-Sitter
  use("nvim-treesitter/nvim-treesitter")

  --LSP
  use("neovim/nvim-lspconfig")
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("onsails/lspkind-nvim")
  --use("github/copilot.vim")

  --Snip
  use "L3MON4D3/LuaSnip"
  use("saadparwaiz1/cmp_luasnip")

  --Language Enhancement
  use("folke/lua-dev.nvim")

  --Code
  use("windwp/nvim-autopairs")
  use("lukas-reineke/indent-blankline.nvim")
  use("mvllow/modes.nvim")
  use("numToStr/Comment.nvim")

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    packer.sync()
  end
end)
