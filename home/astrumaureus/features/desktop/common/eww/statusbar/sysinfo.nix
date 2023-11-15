{
  config,
  ...
}: let
  inherit (config) wm-config;
  inherit (config.theme) colors;

  moduleName = "statusbar/sysinfo";
in {
  xdg.configFile."eww/${moduleName}.yuck".text = let
    cpuIcon = "󰋘";
    cpuLoad = "\${EWW_CPU.avg}";
  in /* yuck */ ''
    (defwidget CPU []
      (box
        :class "CPU widget"
        :space-evenly false
        :orientation "vertical"
        (label
          :class "icon"
          :text "${cpuIcon}"
        )
        (scale
          :class "scale"
          :orientation "vertical"
          :value "${cpuLoad}"
          :min 0 :max 100
        )
      )
    )
  '';

  xdg.configFile."eww/${moduleName}.scss".text = /* scss */ ''
    .CPU {
      &.widget {
        padding: 4px;
        background-color: #${colors.surface0};
        border-radius: ${toString wm-config.rounding}px;
      }

      .icon {
        color: #${colors.pink};
      }

      .scale trough {
        min-width: 6px;
        min-height: 48px;
        border-radius: ${toString wm-config.rounding}px;
        background-color: #${colors.surface1};
        highlight {
          border-radius: ${toString wm-config.rounding}px;
          background-color: #${colors.pink};
        }
      }
    }
  '';
}
