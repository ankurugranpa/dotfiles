-- side bar desing
require('lualine').setup {
  options = {
    icons_enabled = true,
    -- theme = 'onelight',
    theme = 'tokyonight',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {
	-- lualine_a = {'filename'},
	lualine_a = {'filetype'},
        lualine_b = {
          {
            "aerial",
            -- ステータスラインでシンボルを区切るために使用されるセパレーター。
            sep = " ) ",

            -- 上から下にレンダリングするシンボルの数。最後の'N'個のシンボルのみを
            -- レンダリングするには、負の数を指定することも可能です。例えば、'depth = -1'
            -- と設定すると現在のシンボルのみをレンダリングします。
            depth = nil,

            -- 'dense'モードがオンの場合、アイコンはシンボルの近くにレンダリングされません。
            -- 現在のシンボルの種類を表す単一のアイコンのみがステータスラインの先頭に
            -- レンダリングされます。
            dense = false,

            -- denseモードでシンボルを区切るために使用されるセパレーター。
            dense_sep = ".",

            -- シンボルアイコンに色を付けます。
            colored = true,
          },
      },
  },
  inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
  },
  extensions = {'toggleterm'},
}
