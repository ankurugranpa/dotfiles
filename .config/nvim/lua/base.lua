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
-- require("plug-conf/plug-tokyonight")
require("plug-conf/plug-lspkind")
require("plug-conf/plug-indent-blankline")
require("plug-conf/plug-toggleterm")
require("plug-conf/plug-neo-tree")
require("plug-conf/plug-telescope")
require("plug-conf/plug-windows")
-- require("plug-conf/plug-aerial")
-- require("plug-conf/plug-trouble")
-- require("plug-conf/plug-copilotchat")

-- set coloer
vim.cmd[[colorscheme vim]]
-- tokyionightの透過設定
-- vim.cmd[[colorscheme tokyonight]]

-- tokyionightの透過設定
-- vim.cmd([[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]])
require("plug-conf/plug-vimtex")
require("plug-conf/plug-transparent")
require("plug-conf/plug-claudecode")

-- set coloer
-- vim.cmd[[colorscheme vim]]
-- vim.opt.termguicolors = true
-- -- 浮動ウィンドウの背景とボーダーを設定
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", fg = "white" })  -- 浮動ウィンドウ背景
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "cyan" })  -- 浮動ウィンドウ枠線
-- 
-- -- Masonや補完メニュー用のPmenu設定
-- vim.api.nvim_set_hl(0, "Pmenu", { bg = "gray", fg = "black" })       -- 補完メニュー背景
-- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "cyan", fg = "black" })   -- 選択時の色
-- 
-- -- Masonウィンドウのタイトル用の色
-- vim.api.nvim_set_hl(0, "Title", { fg = "yellow", bold = true })     -- タイトル部分の色
-- 
