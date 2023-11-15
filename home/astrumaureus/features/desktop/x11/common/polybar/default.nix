{
  config,
  ...
}: let
  inherit (config.theme) colors;
  barName = "bar0";
in {
  services.polybar = {
    enable = true;

    settings = {
      "colors" = {
        base = "#${colors.base}";
        surface = "#${colors.base}";
        subtext = "#${colors.surface1}";
        text = "#${colors.text}";
        accent = "#${colors.yellow}";
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
        enable-ipc = true;
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
