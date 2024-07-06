require("aerial").setup({
  float = {
    relative = "win",
    override = function(conf, source_winid) -- <- the source_winid is new
      local padding = 1 
      conf.anchor = 'NE'
      conf.row = padding
      conf.col = vim.api.nvim_win_get_width(source_winid) - padding
      return conf
    end,
  },
  layout = {
    -- これらはaerialウィンドウの幅を制御します。
    -- 整数または0から1の間の浮動小数点数（例: 0.4で40%）を使用できます。
    -- min_widthとmax_widthは混在した型のリストにできます。
    -- max_width = {40, 0.2}は「40列または全体の20%のうち小さい方」を意味します
    max_width = { 40, 0.2 },
    width = nil,
    min_width = 10,

    -- aerialウィンドウ用のウィンドウローカルオプションのキー値ペア（例: winhl）
    win_opts = {},

    -- デフォルトでaerialウィンドウを開く方向を決定します。「prefer」のオプションは、
    -- 好ましい方向に他のバッファがある場合は反対方向にウィンドウを開きます
    -- Enum: prefer_right, prefer_left, right, left, float
    -- default_direction = "float",
    default_direction = "float",

    -- aerialウィンドウを開く場所を決定します
    --   edge   - エディタの最も右/左にaerialを開きます
    --   window - 現在のウィンドウの右/左にaerialを開きます
    placement = "window",

    -- シンボルが変わった時、aerialウィンドウを内容に合わせて（最小/最大の制約内で）サイズ変更
    resize_to_content = true,

    -- ウィンドウサイズの均等性を維持（:help CTRL-W_=参照）
    preserve_equality = false,
  },
  -- 自動的にaerialウィンドウを閉じるタイミングを設定します
  --   unfocus       - 元のソースウィンドウを離れるとaerialを閉じます
  --   switch_buffer - ソースウィンドウでバッファを変更するとaerialを閉じます
  --   unsupported   - シンボルソースのないバッファにアタッチするとaerialを閉じます
  close_automatic_events = {"unsupported"},
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
  },
  disable_max_size = 2000000, -- デフォルトは2MB
  highlight_mode = "split_width",
  show_guides = true,

  -- show_guides = trueの場合に使用する文字をカスタマイズします
  guides = {
    -- 子アイテムの下に兄弟アイテムがある場合
    mid_item = "├─",
    -- 子アイテムがリストの最後の場合
    last_item = "└─",
    -- 右にネストされた子ガイドがある場合
    nested_top = "│ ",
    -- 生のインデント
    whitespace = "  ",
  },
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
