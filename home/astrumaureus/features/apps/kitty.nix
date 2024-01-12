# INFO: Kitty: fast, feature-rich, GPU based terminal emulator

{ config, ... }: let
    inherit (config.theme) colors;
in {
    programs.kitty = {
        enable = true;
        settings = let fontFamily = "IosevkaTerm NF"; in {
            sync_to_monitor = "yes";
            window_padding_width = 4;

            # Opacity
            background_opacity = toString config.theme.meta.opacity;

            # Colors
            foreground = "#${colors.text}";
            background = "#${colors.base}";

            # Black
            color0 = "#${colors.surface0}";
            color8 = "#${colors.surface1}";
            # Red
            color1 = "#${colors.red}";
            color9 = "#${colors.red}";
            # Green
            color2 = "#${colors.green}";
            color10 = "#${colors.green}";
            # Yellow
            color3 = "#${colors.yellow}";
            color11 = "#${colors.yellow}";
            # Blue
            color4 = "#${colors.blue}";
            color12 = "#${colors.blue}";
            # Magenta
            color5 = "#${colors.mauve}";
            color13 = "#${colors.mauve}";
            # Cyan
            color6 = "#${colors.sky}";
            color14 = "#${colors.sky}";
            # White
            color7 = "#${colors.text}";
            color15 = "#${colors.text}";
            # Indexed
            # color16 = "#${colors.yellow}";
            # color17 = "#${colors.pink}";
            # color18 = "#${colors.base}";
            # color19 = "#${colors.surface0}";
            # color20 = "#${colors.surface2}";
            # color21 = "#${colors.red}";

            selection_background = "#${colors.text}";
            selection_foreground = "#${colors.base}";

            cursor = "#${colors.text}";
            cursor_shape = "beam";
            url_color = "#${colors.blue}";

            active_border_color = "#${colors.surface1}";
            inactive_border_color = "#${colors.base}";
            active_tab_background = "#${colors.base}";
            active_tab_foreground = "#${colors.text}";
            inactive_tab_background = "#${colors.base}";
            inactive_tab_foreground = "#${colors.surface2}";
            tab_bar_background = "#${colors.base}";

            # Font settings
            font_size = 12;
            font_family      = "${fontFamily} Medium";
            bold_font        = "${fontFamily} Bold";
            italic_font      = "${fontFamily} Medium Italic";
            bold_italic_font = "${fontFamily} Bold Italic";
        };

        keybindings = {
            "ctrl+shift+enter" = "no_op";
        };
    };
}
