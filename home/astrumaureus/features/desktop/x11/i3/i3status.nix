{
  config,
  pkgs,
  ...
}: let
  inherit (config.theme) colors;
in {
  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#${colors.blue}";
      color_degraded = "#${colors.sky}";
      color_bad = "#${colors.mauve}";
      interval = 1;
    };
  };
}
