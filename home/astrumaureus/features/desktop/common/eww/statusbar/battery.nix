{
  config,
  ...
}: let
  inherit (config.theme) colors;
  inherit (config) wm-config;
  batteryPercentage = "\EWW_BATTERY.BAT0.capacity";
  batteryPercentageText = "\${${batteryPercentage}}";
  batteryLowPredicate = "\${${batteryPercentage} > 30 ? '' : 'low'}";
  batteryPredicate = "\${${batteryPercentage} > 10 ? ${batteryLowPredicate} : 'critical'}";
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
          ;; :class "percentage ${batteryPredicate}"
          :text "${batteryPercentageText}%"
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
        background-color: #${colors.surface0};
        border-radius: ${toString wm-config.rounding}px;
      }

      .icon {
        font-size: 16;
        color: #${colors.text};
      }

      .percentage {
        color: #${colors.text};
        &.low { color: #${colors.peach}; }
        &.critical { color: #${colors.red}; }
      }

      .drain {
        color: #${colors.peach};
      }
    }
  '';
}
