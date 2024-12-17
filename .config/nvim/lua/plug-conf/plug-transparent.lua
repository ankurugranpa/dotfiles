require("transparent").setup({
  enable = true,           -- 透過を有効化
  extra_groups = {         -- 追加の透過対象グループ
    "NormalFloat",         -- 浮動ウィンドウ
    "NvimTreeNormal",      -- NvimTreeの背景
    "Pmenu",               -- 補完メニュー
  },
  exclude_groups = {},     -- 透過しないグループ
})

vim.cmd("TransparentEnable") -- 透過を強制的に有効化
