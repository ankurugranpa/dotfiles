local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- Default fanction
keymap('n', 'j', 'gj', opts) -- noremap j gj
keymap('n', 'k', 'gk', opts) -- noremap k gk


-- inser mode
-- keymap("i", ",", ",<Space>", opts)

--  Plugin
-- open fern window

-- let g:fern#renderer = 'nerdfont'
-- let g:fern#default_hidden=1
-- nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=30<CR>
