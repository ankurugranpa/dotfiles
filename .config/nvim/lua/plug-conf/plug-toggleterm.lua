local toggleterm = require('toggleterm')
toggleterm.setup({
	open_mapping = [[<c-z>]],
	hide_numbers = true, -- hide the number column in toggleterm buffers
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
	start_in_insert = true,
	close_on_exit = false,
	direction = 'float',
	shell = vim.o.shell,

	loat_opts = {
		border = 'single',
		width = math.floor(vim.o.columns * 0.9),
		height = math.floor(vim.o.lines * 0.9),
		winblend = 3,
		highlights = { border = "ColorColumn", background = "ColorColumn" },
		title_pos = 'center',
  	},
})
vim.api.nvim_set_keymap("n", "<C-z>", '<Cmd>execute v:count1 . "ToggleTerm"<CR>', { noremap = true, silent = true })

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	open_mapping = [[<c-g>]],
	start_in_insert = true,
	count = 5,
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",
	float_opts = {
	border = "double",
	},
	-- function to run on opening the terminal
	on_open = function(term)
	-- vim.cmd("startinsert!")
	vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
	end,
	-- function to run on closing the terminal
	on_close = function(term)
	vim.cmd("startinsert!")
	end,
})

function _lazygit_toggle()
	lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<c-g>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
