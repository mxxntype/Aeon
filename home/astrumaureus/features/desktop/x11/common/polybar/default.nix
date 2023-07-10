{
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
  barName = "bar0";
in {
  services.polybar = {
    enable = true;

    settings = {
      "colors" = {
        base = "#${colors.base00}";
        surface = "#${colors.base01}";
        subtext = "#${colors.base04}";
        text = "#${colors.base05}";
        accent = "#${colors.base09}";
      };

      "bar/${barName}" = {
        modules.center = "bspwm";
      };

      "module/bspwm" = {
        type = "internal/bspwm";
        label = {
          empty = {
            foreground = "\${colors.subtext}";
          };
          occupied = {
            foreground = "\${colors.text}";
          };
          urgent = {
            foreground = "\${colors.text}";
          };
          focused = {
            foreground = "\${colors.accent}";
          };
        };
      };
    };

    script = "polybar ${barName} &amp;";
  };
}
