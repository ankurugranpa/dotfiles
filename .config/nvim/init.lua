-- load setting file 
require('base')
require('keymaps')
require('options')
require('plugins')
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.api.nvim_win_set_option(0, 'signcolumn', 'yes:2')
