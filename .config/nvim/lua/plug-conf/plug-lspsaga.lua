-- local status, saga = pcall(require, "lspsaga")
-- if (not status) then return end
-- 
-- local keymap = vim.keymap.set
-- 
-- saga.setup{
--   ui = {
--     -- currently only round theme
--     theme = 'round',
--     -- theme = 'tokyonight',
--     -- this option only work in neovim 0.9
--     title = false,
--     -- border type can be single,double,rounded,solid,shadow.
--     border = 'rounded',
--     winblend = 6,
--     expand = '',
--     collapse = '',
--     preview = ' ',
--     code_action = '💡',
--     diagnostic = '',
--     incoming = ' ',
--     outgoing = ' ',
--     colors = {
--       --float window normal background color
--       -- normal_bg = '#232136',
--     },
--     kind = {},
--   },
-- 
--   preview = {
--     lines_above = 1,
--     lines_below = 10,
--   },
--   scroll_preview = {
--     scroll_down = '<C-f>',
--     scroll_up = '<C-b>',
--   },
--   request_timeout = 2000,
-- 
--   finder = {
--     edit = { 'o', '<CR>' },
--     vsplit = 's',
--     split = 'i',
--     tabe = 't',
--     quit = { 'q', '<ESC>' },
--   },
-- -- ライトバルブをすべて無効
--   lightbulb = {
--     enable = false,
--     enable_in_insert = false,
--     sign = false,
--     sign_priority = 40,
--     virtual_text = false,
--   }, 
-- 
--   diagnostic = {
--     show_code_action = false,
--     show_source = true,
--     jump_num_shortcut = true,
--     keys = {
--       exec_action = 'o',
--       quit = 'q',
--       go_action = 'g'
--     },
--   },
--   -- winbarのシンボルを無効化
--   symbol_in_winbar = {
--     enable = false,
--     separator = ' ',
--     hide_keyword = true,
--     show_file = true,
--     folder_level = 2,
--     respect_root = false,
--     color_mode = true,
--   },
-- }
-- 
-- keymap("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
-- keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { silent = true })
-- keymap("n", "rn", "<cmd>Lspsaga rename<CR>", { silent = true })
-- keymap("n", "K", "<cmd>Lspsaga hover_doc ++quiet<CR>", { silent = true }) 
-- keymap("n", "<space>e", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
-- -- keymap("n", "<space>a", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
-- -- keymap({'n', '<A-d>', '<cmd>Lspsaga term_toggle'})
-- -- keymap({"n","v"}, "ma", "<cmd>Lspsaga code_action<CR>", { silent = true })
-- -- keymap("n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
-- -- keymap("n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
local lspsaga = require("lspsaga")
lspsaga.setup({ -- defaults ...
	ui = {
		code_action = "󰌶",
		diagnostic = "",
		expand = '',
		collapse = '',
	},
	lightbulb = {
		virtual_text = false,
	},
	finder = {
		scroll_down = "<C-f>",
		scroll_up = "<C-b>", -- quit can be a table
		quit = { "q", "<ESC>" },
	},
	symbol_in_winbar = {
		enable = false,
		show_file = false,
	},
})

-- vim.keymap.set("n", "[_Lsp]r", "<cmd>Lspsaga rename ++project<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "M", "<cmd>Lspsaga code_action<cr>", { silent = true, noremap = true })
-- vim.keymap.set("x", "M", ":<c-u>Lspsaga range_code_action<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "?", "<cmd>Lspsaga hover_doc<cr>", { silent = true, noremap = true })
-- -- vim.keymap.set("n", "[_Lsp]j", "<cmd>Lspsaga diagnostic_jump_next<cr>", { silent = true, noremap = true })
-- -- vim.keymap.set("n", "[_Lsp]k", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { silent = true, noremap = true })
-- -- vim.keymap.set("n", "[_Lsp]f", "<cmd>Lspsaga lsp_finder<CR>", { silent = true, noremap = true })
-- -- vim.keymap.set("n", "[_Lsp]s", "<Cmd>Lspsaga signature_help<CR>", { silent = true, noremap = true })
-- -- vim.keymap.set("n", "[_Lsp]d", "<cmd>Lspsaga preview_definition<CR>", { silent = true })
-- -- vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true, noremap = true })
-- -- -- vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
-- vim.keymap.set("n", "[_Lsp]l", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "[_Lsp]c", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "[_Lsp]b", "<cmd>Lspsaga show_buf_diagnostics<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "[E", function()
-- 	require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true, noremap = true })
-- vim.keymap.set("n", "]E", function()
-- 	require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "[_Lsp]I", "<cmd>Lspsaga incoming_calls<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "[_Lsp]O", "<cmd>Lspsaga outgoing_calls<CR>", { silent = true, noremap = true })
