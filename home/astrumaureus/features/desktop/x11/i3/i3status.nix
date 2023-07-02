{
  config,
  pkgs,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#${colors.base0D}";
      color_degraded = "#${colors.base0C}";
      color_bad = "#${colors.base0E}";
      interval = 1;
    };
  };
}
