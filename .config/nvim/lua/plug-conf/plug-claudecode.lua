-- ノーマルモード
vim.keymap.set("n", "<leader>c", "<cmd>ClaudeCode<cr>")
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>")
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>")
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>")
vim.keymap.set("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>")
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>")
vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>")
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>")

-- ビジュアルモード
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>")



-- ターミナルモードで Esc で抜ける
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })
