local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

--------------------------------------------------
-- config builder
--------------------------------------------------
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

--------------------------------------------------
-- Appearance
--------------------------------------------------
config.color_scheme = 'MaterialDesignColors'
config.window_background_opacity = 0.8
config.audible_bell = "Disabled"

config.font = wezterm.font(
  "HackGen Console NF Regular",
  { weight = "Medium", stretch = "Normal", style = "Normal" }
)
config.font_size = 14

--------------------------------------------------
-- Tab bar
--------------------------------------------------
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

--------------------------------------------------
-- Startup: fullscreen
--------------------------------------------------
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

--------------------------------------------------
-- Opacity control events
--------------------------------------------------
wezterm.on("decrease-opacity", function(window)
  local overrides = window:get_config_overrides() or {}
  overrides.window_background_opacity =
    math.max((overrides.window_background_opacity or 1.0) - 0.1, 0.1)
  window:set_config_overrides(overrides)
end)

wezterm.on("increase-opacity", function(window)
  local overrides = window:get_config_overrides() or {}
  overrides.window_background_opacity =
    math.min((overrides.window_background_opacity or 1.0) + 0.1, 1.0)
  window:set_config_overrides(overrides)
end)

--------------------------------------------------
-- Split Window function
--------------------------------------------------
local function split_with_cwd(split_action)
  return wezterm.action_callback(function(window, pane)
    local cwd = pane:get_current_working_dir()

    if cwd then
      -- Windows パスが混ざったら捨てる
      if cwd.file_path:match("^/C:") or cwd.file_path:match("^C:") then
        cwd = nil
      else
        cwd = cwd.file_path
      end
    end

    window:perform_action(
      split_action {
        domain = "CurrentPaneDomain",
        cwd = cwd,
      },
      pane
    )
  end)
end



--------------------------------------------------
-- Leader key
--------------------------------------------------
config.leader = {
  key = 'b',
  mods = 'CTRL',
  timeout_milliseconds = 1000,
}

--------------------------------------------------
-- Key bindings
--------------------------------------------------
config.keys = {
  -- opacity
  { key = "1", mods = "LEADER", action = act.EmitEvent "decrease-opacity" },
  { key = "2", mods = "LEADER", action = act.EmitEvent "increase-opacity" },

  -- fullscreen
  { key = "f", mods = "SHIFT|META", action = act.ToggleFullScreen },

  -- tabs
  { key = "t", mods = "SHIFT|CTRL", action = act.SpawnTab "CurrentPaneDomain" },

  -- split panes
  -- { key = "\\", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  -- { key = "-",  mods = "LEADER", action = act.SplitVertical   { domain = "CurrentPaneDomain" } },
  { key = "\\", mods = "LEADER", action = split_with_cwd(act.SplitHorizontal) },
  { key = "-",  mods = "LEADER", action = split_with_cwd(act.SplitVertical) },


  -- close / zoom
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

  -- pane navigation
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection "Left" },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection "Down" },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection "Up" },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection "Right" },

  -- pane resize
  { key = "H", mods = "LEADER", action = act.AdjustPaneSize { "Left", 5 } },
  { key = "J", mods = "LEADER", action = act.AdjustPaneSize { "Down", 5 } },
  { key = "K", mods = "LEADER", action = act.AdjustPaneSize { "Up", 5 } },
  { key = "L", mods = "LEADER", action = act.AdjustPaneSize { "Right", 5 } },

  -- font size
  { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },

  -- copy / paste
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "v", mods = "CTRL", action = act.PasteFrom "Clipboard" },

  -- launcher / workspace
  { key = "m", mods = "LEADER", action = act.ShowLauncher },
  { key = "s", mods = "LEADER", action = act.ShowLauncherArgs {
      flags = "WORKSPACES",
      title = "Select workspace",
    },
  },
}

--------------------------------------------------
-- Default: WSL
--------------------------------------------------
-- config.default_domain = "WSL:Ubuntu-22.04"
-- config.default_prog = { "/usr/bin/env", "zsh", "-l" }

config.default_prog = { "pwsh.exe", "-NoLogo" }


--------------------------------------------------
-- Launch menu (select shell)
--------------------------------------------------
config.launch_menu = {
  {
    label = "WSL (Ubuntu 22.04)",
    domain = { DomainName = "WSL:Ubuntu-22.04" },
  },
  {
    label = "PowerShell (pwsh)",
    args = { "pwsh.exe", "-NoLogo" },
  },
  {
    label = "Windows PowerShell",
    args = { "powershell.exe", "-NoLogo" },
  },
}

--------------------------------------------------
-- SSH domains
--------------------------------------------------
config.ssh_domains = {
  {
    name = "yzgpu",
    remote_address = "yzaidgpus.yz.yamagata-u.ac.jp",
    username = "tfx73770",
    multiplexing = "WezTerm",
  },
}

--------------------------------------------------
-- Done
--------------------------------------------------
return config

