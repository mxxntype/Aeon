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
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };

    settings = {
      # Splits
      enabled_layouts = "horizontal";
      window_border_width = "1.5";
      window_padding_width = 8;
      window_margin_width = 6;
      single_window_margin_width = 8;

      # Opacity
      background_opacity = "0.80";

      # Colors
      foreground = "#${colors.base05}";
      background = "#${colors.base01}";

      color0 = "#${colors.base02}";
      color8 = "#${colors.base03}";

      color1 = "#${colors.base06}";
      color9 = "#${colors.base06}";

      color2 = "#${colors.base0A}";
      color10 = "#${colors.base0A}";

      color3 = "#${colors.base09}";
      color11 = "#${colors.base09}";

      color4 = "#${colors.base0D}";
      color12 = "#${colors.base0D}";

      color5 = "#${colors.base0E}";
      color13 = "#${colors.base0E}";

      color6 = "#${colors.base0B}";
      color14 = "#${colors.base0B}";

      color7 = "#${colors.base05}";
      color15 = "#${colors.base05}";
      # color16 = "#${colors.base09}";
      # color17 = "#${colors.base0F}";
      # color18 = "#${colors.base01}";
      # color19 = "#${colors.base02}";
      # color20 = "#${colors.base04}";
      # color21 = "#${colors.base06}";

      selection_background = "#${colors.base05}";
      selection_foreground = "#${colors.base00}";

      cursor = "#${colors.base05}";
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
