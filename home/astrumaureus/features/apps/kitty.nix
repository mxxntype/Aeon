# INFO: Kitty: fast, feature-rich, GPU based terminal emulator

{
  config,
  pkgs,
  ...
}: let
  # Launch Kitty instead of xterm
  kitty-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.programs.kitty.package}/bin/kitty -1 "$@"
  '';

  inherit (config.colorscheme) colors;
in {
  programs.kitty = {
    enable = true;

    font = {
      name = "BigBlueTermPlus Nerd Font";
      size = 12;
    };

    settings = {
      # Splits
      enabled_layouts = "horizontal";
      window_border_width = "1.5";
      window_padding_width = 4;
      # window_margin_width = 6;
      single_window_margin_width = 4;

      # Opacity
      background_opacity = "0.9";

      # Colors
      foreground = "#${colors.base05}";
      background = "#${colors.base01}";

      # Black
      color0 = "#${colors.base02}";
      color8 = "#${colors.base03}";
      # Red
      color1 = "#${colors.base06}";
      color9 = "#${colors.base06}";
      # Green
      color2 = "#${colors.base0A}";
      color10 = "#${colors.base0A}";
      # Yellow
      color3 = "#${colors.base09}";
      color11 = "#${colors.base09}";
      # Blue
      color4 = "#${colors.base0D}";
      color12 = "#${colors.base0D}";
      # Magenta
      color5 = "#${colors.base0E}";
      color13 = "#${colors.base0E}";
      # Purple
      color6 = "#${colors.base0B}";
      color14 = "#${colors.base0B}";
      # White
      color7 = "#${colors.base05}";
      color15 = "#${colors.base05}";
      # Indexed
      # color16 = "#${colors.base09}";
      # color17 = "#${colors.base0F}";
      # color18 = "#${colors.base01}";
      # color19 = "#${colors.base02}";
      # color20 = "#${colors.base04}";
      # color21 = "#${colors.base06}";

      selection_background = "#${colors.base05}";
      selection_foreground = "#${colors.base00}";

      cursor = "#${colors.base05}";
      cursor_shape = "beam";
      url_color = "#${colors.base04}";

      active_border_color = "#${colors.base03}";
      inactive_border_color = "#${colors.base01}";
      active_tab_background = "#${colors.base00}";
      active_tab_foreground = "#${colors.base05}";
      inactive_tab_background = "#${colors.base01}";
      inactive_tab_foreground = "#${colors.base04}";
      tab_bar_background = "#${colors.base01}";
    };
  };

  # The alias defined above
  home.packages = [
    kitty-xterm
  ];
}
