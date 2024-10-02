-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act    = wezterm.action

-- SSH settings:
config.ssh_backend = "Ssh2"

-- This is where you actually apply your config choices

-- Disable to prevent problems with CLI apss.
config.use_dead_keys = false
-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 10000

config.audible_bell = "Disabled"



-- For example, changing the color scheme:
config.color_scheme = 'catppuccin-frappe'
-- config.font = wezterm.font 'mononoki Nerd Font Mono'
config.font_size = 16
config.window_background_opacity = 0.96

config.ssh_domains = {
  {
    name = 'crimson',
    remote_address = 'crimson',
    username = 'vst',
    multiplexing = 'WezTerm',
  },
  {
    name = 'itu',
    remote_address = '10.139.31.66',
    multiplexing = 'WezTerm'
  }
}




-- Hide the tab bar if there is only one tab
config.hide_tab_bar_if_only_one_tab = true
-- Makes tabs less fancy and take less space
config.use_fancy_tab_bar = false

-- Disable default shortcuts.
config.disable_default_key_bindings = true


config.keys = {
  -- CTRL-SHIFT-l activates the debug overlay
  { key = 'L', mods = 'CTRL', action = act.ShowDebugOverlay },
  -- Copy selection to system cilpboard.
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo("Clipboard") },
  -- Paste contents of system clipboard.
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom("Clipboard") },
  -- Increases the font size of the current window by 10%
  { key = '+', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  -- Decreases the font size of the current window by 10%
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  -- This will create a new split and run the `top` program inside it
  { key = 'o', mods = 'CMD|SHIFT', action = wezterm.action.SplitVertical },
  -- This will create a new split and run the `top` program inside it
  { key = 'e', mods = 'CMD|SHIFT', action = wezterm.action.SplitPane { direction = 'Right' } },
  -- Pane navigation:
  { key = 'j', mods = 'CMD', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CMD', action = act.ActivatePaneDirection 'Up' },
  { key = 'h', mods = 'CMD', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CMD', action = act.ActivatePaneDirection 'Right' },
  -- Manage Tabs
  { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain', },
  { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentTab { confirm = false }, },
  { key = 'LeftArrow',  mods = 'CMD', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD', action = act.ActivateTabRelative(1)  },
  { key = 'm', mods = 'CMD|SHIFT', action = wezterm.action.TogglePaneZoomState },

  -- Swap panes
  { key = '0', mods = 'CTRL', action = act.PaneSelect { mode = 'SwapWithActive' } },

}

-- and finally, return the configuration to wezterm
return config
