local wezterm = require 'wezterm'

local config = {}


if wezterm.config_builder then
	  config = wezterm.config_builder()
end
-- カラースキーム
config.color_scheme = 'MaterialDesignColors'

-- 背景透過
config.window_background_opacity = 0.8

wezterm.on("decrease-opacity", function(window)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        overrides.window_background_opacity = 1.0
    end
    overrides.window_background_opacity = overrides.window_background_opacity - 0.1
    if overrides.window_background_opacity < 0.1 then
        overrides.window_background_opacity = 0.1
    end
    window:set_config_overrides(overrides)
end)

wezterm.on("increase-opacity", function(window)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        overrides.window_background_opacity = 1.0
    end
    overrides.window_background_opacity = overrides.window_background_opacity + 0.1
    if overrides.window_background_opacity > 1.0 then
        overrides.window_background_opacity = 1.0
    end
    window:set_config_overrides(overrides)
end)


config.show_new_tab_button_in_tab_bar = false -- tab barの+ボタン消す
config.hide_tab_bar_if_only_one_tab = true -- tab bar消す(1つの時のみ)
-- config.show_close_tab_button_in_tabs = false -- tabの閉じるボタン非表示
config.colors = {
   tab_bar = {
     inactive_tab_edge = "none",
   },
}


-- フルスクリーン起動
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()
end)

config.font = wezterm.font("HackGen Console NF Regular", {weight="Medium", stretch="Normal", style="Normal"}) -- フォントの設定
config.font_size = 14


config.audible_bell = "Disabled" -- ベル通知の設定

-- LEADERキーの設定
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
-- ショートカットキー設定
local act = wezterm.action
config.keys = {
  -- 透明度の切り替え
  { key = "1", mods = 'LEADER', action = wezterm.action { EmitEvent = "decrease-opacity" }, },
  { key = "2", mods = 'LEADER', action = wezterm.action { EmitEvent = "increase-opacity" }, },
  -- フルスクリーン切り替え
  { key = "f", mods = 'SHIFT|META', action = wezterm.action.ToggleFullScreen, },
  -- 新しいタブを作成
  { key = "t", mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain',},
  -- (LEADER+|で)新しいペイン(縦)を作成
  { key = "\\", mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },},
  -- (LEADER+-で)新しいペイン(横)を作成
  { key = "-", mods = 'LEADER',  action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },},
  -- 現在のペインを閉じる
  { key = "x", mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true },},
  { key = "z", mods = 'LEADER', action = wezterm.action.TogglePaneZoomState, },
  -- ペインの移動
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  -- ペインのサイズ変更
  { key = "H", mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 },},
  { key = "J", mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = "K", mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = "L", mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },
  -- フォントサイズの変更
  { key = "+",  mods = "CTRL",  action = wezterm.action.IncreaseFontSize },
  { key = "-",  mods = "CTRL",  action = wezterm.action.DecreaseFontSize },
  -- コピーモード
  { key = "[",  mods = 'LEADER',action = wezterm.action.ActivateCopyMode },
  -- コピペの設定
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
  -- workspace setting
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'WORKSPACES' , title = "Select workspace" },},
  -- 起動menu
  { key = "m", mods = 'LEADER', action = wezterm.action.ShowLauncher, },
}

-- config.SpawnCommandInNewWindow{
--     {
--       label = "WSL2",
--       args = {"wsl.exe"},
--     },
--     {
--       label = "PowerShell",
--       args = {"powershell.exe"},
--     },
--     {
--       label = "Custom Directory",
--       cwd = "C:\\path\\to\\directory",
--       args = {"powershell.exe"},
--     },
-- }

config.launch_menu = {
   {
     label = 'pshell',
     args = { 'powershell.exe' , '-NoLogo' },
   },
}

-- config.default_domain = "powershell.exe"
config.default_prog = { 'pwsh.exe', '-NoLogo' }



-- Ubuntu 20.04 をデフォルトで起動する
-- config.default_domain = 'WSL:Ubuntu-24.04'
-- 
-- config.default_prog = {"/usr/bin/env", "zsh", "-l", "-c", "exec /usr/bin/env zsh"}

-- username は自分のユーザー名に置き換えてください

-- config.default_cwd = "/home/ahahahaha"

config.ssh_domains = {
    {
      name = "yzgpu",
      remote_address = "yzaidgpus.yz.yamagata-u.ac.jp",
      multiplexing = "WezTerm",
      username = "tfx73770"
      -- remote_wezterm_path = "/home/tfx73770/.local/bin/wezterm",
    },
}
  -- a
  -- config.default_prog = { "wezterm" },
  -- config.default_domain = "Local",

return config
