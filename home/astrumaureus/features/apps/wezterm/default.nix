# INFO: Wezterm (possible Rust replacement for kitty)

{
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
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
        active_titlebar_bg = '${colors.base00}',

        -- The overall background color of the tab bar when the window is not focused
        inactive_titlebar_bg = '${colors.base00}',
      }

      config.enable_tab_bar = false

      --[[ Nix-friendly colorscheme ]]--
      config.colors = {
        foreground = '${colors.base05}',  -- The default text color
        background = '${colors.base00}',   -- The default background color

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
        scrollbar_thumb = '${colors.base00}',

        -- The color of the split lines between panes
        split = '#444444',

        ansi = {
          '${colors.base01}',
          '${colors.base0E}',
          '${colors.base0D}',
          '${colors.base0A}',
          '${colors.base08}',
          '${colors.base09}',
          '${colors.base0B}',
          '${colors.base05}',
        },
        brights = {
          '${colors.base03}',
          '${colors.base0E}',
          '${colors.base0D}',
          '${colors.base0A}',
          '${colors.base08}',
          '${colors.base09}',
          '${colors.base0B}',
          '${colors.base05}',
        },

        --[[ Tabs ]]--
        tab_bar = {
          -- The color of the strip that goes along the top of the window
          -- (does not apply when fancy tab bar is in use)
          background = '${colors.base01}',

          -- The active tab is the one that has focus in the window
          active_tab = {
            -- Background
            bg_color = '${colors.base00}', -- The color of the background area for the tab
            fg_color = '${colors.base05}', -- The color of the text for the tab
            
            -- Font
            intensity = 'Normal', -- "Half", "Normal" or "Bold"
            underline = 'None',   -- "None", "Single" or "Double"
          },

          inactive_tab = {
            -- Background
            bg_color = '${colors.base00}', -- The color of the background area for the tab
            fg_color = '${colors.base04}', -- The color of the text for the tab
          },

          -- You can configure some alternate styling when the mouse pointer
          -- moves over inactive tabs
          inactive_tab_hover = {
            bg_color = '${colors.base00}',
            fg_color = '${colors.base05}',
          },

          -- The new tab button that let you create new tabs
          new_tab = {
            bg_color = '${colors.base01}',
            fg_color = '${colors.base09}',
            intensity = 'Bold',
          },

          -- Alternate styling when the mouse hovers over the new tab button
          new_tab_hover = {
            bg_color = '${colors.base02}',
            fg_color = '${colors.base09}',
            intensity = 'Bold',
          },
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

      return config
    '';
  };
}
