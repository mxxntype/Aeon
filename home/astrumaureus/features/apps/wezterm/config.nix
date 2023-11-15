# INFO: Wezterm configuration

{
  config,
  ...
}: let
  inherit (config.theme) colors;
in {
  programs.wezterm = {
    extraConfig = /* lua */ ''
      local wezterm = require 'wezterm'
      local config = {}

      --[[ Fonts ]]--
      config.font_size = 10.0
      config.underline_thickness = 2

      config.window_background_opacity = 0.9

      --[[ Window & Tabs ]]--
      config.window_frame = {
        -- The font used in the tab bar.
        font = wezterm.font { family = 'JetBrains Mono' },

        -- The size of the font in the tab bar.
        font_size = 10.0,

        -- The overall background color of the tab bar when the window is focused
        active_titlebar_bg = '${colors.base}',

        -- The overall background color of the tab bar when the window is not focused
        inactive_titlebar_bg = '${colors.base}',
      }

      config.enable_tab_bar = false

      --[[ Nix-friendly colorscheme ]]--
      config.colors = {
        foreground = '${colors.text}',  -- The default text color
        background = '${colors.base}',   -- The default background color

        -- Overrides the cell background color when the current cell is occupied by the
        -- cursor and the cursor style is set to Block
        cursor_bg = '#52ad70',
        -- Overrides the text color when the current cell is occupied by the cursor
        cursor_fg = 'black',
        -- Specifies the border color of the cursor when the cursor style is set to Block,
        -- or the color of the vertical or horizontal bar when the cursor style is set to
        -- Bar or Underline.
        cursor_border = '#52ad70',

        -- the foreground color of selected text
        selection_fg = 'black',
        -- the background color of selected text
        selection_bg = '#fffacd',

        -- The portion that represents the current viewport
        scrollbar_thumb = '${colors.base}',

        -- The color of the split lines between panes
        split = '#444444',

        ansi = {
          '${colors.base}',
          '${colors.mauve}',
          '${colors.blue}',
          '${colors.green}',
          '${colors.peach}',
          '${colors.yellow}',
          '${colors.teal}',
          '${colors.text}',
        },
        brights = {
          '${colors.surface1}',
          '${colors.mauve}',
          '${colors.blue}',
          '${colors.green}',
          '${colors.peach}',
          '${colors.yellow}',
          '${colors.teal}',
          '${colors.text}',
        },

        -- Indexed colors
        indexed = {
          [136] = '#af8700',
        },

        -- Since: 20220319-142410-0fcdea07
        -- When the IME, a dead key or a leader key are being processed and are effectively
        -- holding input pending the result of input composition, change the cursor
        -- to this color to give a visual cue about the compose state.
        compose_cursor = 'orange',

        -- Colors for copy_mode and quick_select
        -- available since: 20220807-113146-c2fee766
        -- In copy_mode, the color of the active text is:
        -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
        -- 2. selection_* otherwise
        copy_mode_active_highlight_bg = { Color = '#000000' },
        -- use `AnsiColor` to specify one of the ansi color palette values
        -- (index 0-15) using one of the names "Black", "Maroon", "Green",
        --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
        -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
        copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
        copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
        copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

        quick_select_label_bg = { Color = 'peru' },
        quick_select_label_fg = { Color = '#ffffff' },
        quick_select_match_bg = { AnsiColor = 'Navy' },
        quick_select_match_fg = { Color = '#ffffff' },
      }

      config.disable_default_key_bindings = true;
      config.keys = {
        -- Paste from clipboard
        { key = 'V', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard'},
        -- Copy to clipboard
        { key = 'C', mods = 'CTRL', action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection'},
      }

      return config
    '';
  };
}
