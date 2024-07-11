local wezterm = require 'wezterm'

local config = {}


if wezterm.config_builder then
	  config = wezterm.config_builder()
end
-- カラースキーム
config.color_scheme = 'MaterialDesignColors'

-- 背景透過
-- config.window_background_opacity = 0.0
config.window_background_opacity = 0.7

-- フルスクリーン起動
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()
end)

-- フォントの設定
config.font = wezterm.font("HackGen Console NF Regular", {weight="Medium", stretch="Normal", style="Normal"})
config.font_size = 14

-- ベル通知の設定
config.audible_bell = "Disabled"

-- LEADERキーの設定
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
-- ショートカットキー設定
local act = wezterm.action
config.keys = {
  -- フルスクリーン切り替え
  { key = 'f', mods = 'SHIFT|META', action = wezterm.action.ToggleFullScreen, },
  -- 新しいタブを作成
  { key = 't', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain',},
  -- (LEADER+|で)新しいペイン(縦)を作成
  { key = '\\', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },},
  -- (LEADER+-で)新しいペイン(横)を作成
  { key = '-', mods = 'LEADER',  action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },},
  -- 現在のペインを閉じる
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true },},
  { key = 'z', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState, },
  -- ペインの移動
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  -- ペインのサイズ変更
  { key = 'H', mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 },},
  { key = 'J', mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },
  -- フォントサイズの変更
  { key = "+",  mods = "CTRL",  action = wezterm.action.IncreaseFontSize },
  { key = "-",  mods = "CTRL",  action = wezterm.action.DecreaseFontSize },
  -- コピーモード
  { key = '[',  mods = 'LEADER', mods = 'CTRL',  action = wezterm.action.ActivateCopyMode },
  -- コピペの設定
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") }
}


-- Ubuntu 20.04 をデフォルトで起動する
config.default_domain = 'WSL:Ubuntu-24.04'

config.default_prog = {"/usr/bin/env", "zsh", "-l", "-c", "exec /usr/bin/env zsh"}

-- username は自分のユーザー名に置き換えてください

config.default_cwd = "/home/ahahahaha"
return config
