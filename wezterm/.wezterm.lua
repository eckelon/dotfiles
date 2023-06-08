-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Mocha'

config.font =
  wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })
config.font_size=18

config.keys = {
  {
    key = 'Z',
    mods = 'CTRL',
    action = wezterm.action.TogglePaneZoomState,
  },{
    key = 'e',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },

  },{
    key = 'e',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
}


return config
