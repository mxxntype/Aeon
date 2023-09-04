{
  config,
  ...
}: let
  inherit (config) wm-config;
  inherit (config.colorscheme) colors;

  moduleName = "statusbar/sysinfo";
in {
  xdg.configFile."eww/${moduleName}.yuck".text = let
    cpuIcon = "󰋘";
    cpuLoad = "\${EWW_CPU.avg}";
  in ''
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

  xdg.configFile."eww/${moduleName}.scss".text = ''
    .CPU {
      &.widget {
        padding: 4px;
        background-color: #${colors.base02};
        border-radius: ${toString wm-config.rounding}px;
      }
    }
  '';
}
