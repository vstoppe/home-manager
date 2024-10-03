-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act    = wezterm.action

config = {
  -- SSH settings:
  -- ssh_backend = "Ssh2" dos not support request_auth_agent_forwarding
  ssh_backend = "LibSsh"; -- <= works on match

  -- Initial window size settings:
  initial_cols = 160;
  initial_rows = 40;

  -- General settings:
  audible_bell = "Disabled";
  disable_default_key_bindings = true;
  scrollback_lines = 10000;
  use_dead_keys = false;

  -- Appearance:
  color_scheme = 'catppuccin-frappe';
  font_size = 16;
  hide_tab_bar_if_only_one_tab = true;
  use_fancy_tab_bar = true; -- more modern style for taskbar
  window_background_opacity = 0.96;

  -- Set domains:
  ssh_domains = {
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
  },

  -- Configure key bindings
  keys = {
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
}

-- and finally, return the configuration to wezterm
return config
