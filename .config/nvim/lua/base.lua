vim.cmd("autocmd!")
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

vim.scriptencoding = "utf-8"

vim.wo.number = true

-- load plugin list
local plugins = require('plugins')

-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins)


require("plug-conf/plug-cmp")
require("plug-conf/plug-mason")
require("plug-conf/plug-lspconfig")
require("plug-conf/plug-lualine")
require("plug-conf/plug-lspsaga")
require("plug-conf/plug-tokyonight")
require("plug-conf/plug-lspkind")
require("plug-conf/plug-indent-blankline")
require("plug-conf/plug-toggleterm")
require("plug-conf/plug-neo-tree")
require("plug-conf/plug-telescope")
require("plug-conf/plug-trouble")

-- set coloer
vim.cmd[[colorscheme tokyonight]]
