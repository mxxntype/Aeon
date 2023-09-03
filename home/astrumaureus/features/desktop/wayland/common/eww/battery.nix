{
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
  inherit (config) wm-config;
  batteryPercentage = "\${EWW_BATTERY.BAT0.capacity}";
  batteryLowPredicate = "\${${batteryPercentage} > 30 ? \"\" : \"low\"}";
  batteryPredicate = "\${${batteryPercentage} > 10 ? ${batteryLowPredicate} : \"critical\"}";
  powerDrain = "\${powerdrain}";
in {
  xdg.configFile."eww/statusbar/battery.yuck".text = ''
    (defpoll powerdrain
      :interval "2s"
      "powerdrain"
    )
    (defwidget battery []
      (box
        :class "battery widget"
        :orientation "vertical"
        (label
          :class "icon"
          :text "󰁹"
        )
        (label
          :class "percentage ${batteryPercentage}"
          :text "${batteryPercentage}%"
        )
        (label
          :class "drain"
          :text "${powerDrain}W"
        )
      )
    )
  '';

  xdg.configFile."eww/statusbar/battery.scss".text = ''
    .battery {
      &.widget {
        padding: 4px;
        margin-bottom: 4px;
        margin-top: 4px;
        background-color: #${colors.base02};
        border-radius: ${toString wm-config.rounding}px;
      }

      .icon {
        font-size: 16;
        color: #${colors.base0A};
      }

      .percentage {
        color: #${colors.base0A};
        &.low { color: #${colors.base08}; }
        &.critical { color: #${colors.base06}; }
      }

      .drain {
        color: #${colors.base08};
      }
    }
  '';
}
