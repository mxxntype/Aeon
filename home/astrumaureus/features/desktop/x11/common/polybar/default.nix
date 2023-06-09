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
        subtext = "#${colors.base03}";
        text = "#${colors.base05}";
        accent = "#${colors.base09}";
      };

      "bar/${barName}" = {
        modules = {
          left = "";
          center = "bspwm";
          right = "battery date";
        };
        font."0" = "JetBrainsMono Nerd Font:pixelsize=10:weight=bold;0";
        module.margin = 1;
        tray = {
          position = "right";
          padding = 8;
        };
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

      "module/date" = {
        type = "internal/date";
        interval = 10.0;

        time = "%H:%M";
        label = "%time%";
        format = {
          text = "󰥔 <label>";
          foreground = "\${colors.text}";
        };
      };
      
      "module/battery" = {
        type = "internal/battery";
      };
    };

    script = "polybar ${barName} &amp;";
  };
}
