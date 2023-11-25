{ config, inputs, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };

  inherit (shared) colors style conditional;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.battery) widgetName moduleName variables;
  inherit (config) wm-config;

  EWW_BATTERY = rec {
    name = "EWW_BATTERY";
    total_avg = "${name}.total_avg";
    status = "${name}.BAT0.status";
  };

  icons = {
    chargeLevel = "[${lib.concatStringsSep ", " [
      "\\\"󰁺\\\"" # Manual JSON because of nested escapes
      "\\\"󰁻\\\""
      "\\\"󰁽\\\""
      "\\\"󰁽\\\""
      "\\\"󰁾\\\""
      "\\\"󰁿\\\""
      "\\\"󰂁\\\""
      "\\\"󰂁\\\""
      "\\\"󰂂\\\""
      "\\\"󰁹\\\""
    ]}]";
    charging = "󰚥";
    discharging = "󱐋";
  };

  chargeLevels = {
    normal = {
      color = colors.green;
    };
    low = {
      threshold = 30;
      color = colors.peach;
    };
    critical = {
      threshold = 15;
      color = colors.red;
    };
  };

  percentage = "\${ round(${EWW_BATTERY.total_avg}, 0) }";
in {
  xdg.configFile."eww/${moduleName}.yuck".text = /* yuck */ ''
    (defvar ${variables.chargeLevelIcons} "${icons.chargeLevel}")
    (defpoll ${variables.powerdrain}
      :interval "2s"
      "powerdrain")
    
    (defwidget ${widgetName} [position]
      (box
        :halign position
        :space-evenly false
        :style "${style [
          "background: #${colors.surface0}"
          "border-radius: ${toString (wm-config.rounding * 512)}px"
          "margin-top: 4px"
          "padding-left: 8px"
          "padding-right: 2px"
        ]}"

        ;; Icon
        (label
          :text "''${${variables.chargeLevelIcons}[round( ${EWW_BATTERY.total_avg} / 10, 0) - 1]}"
          :style "${style [
            "color: #\${ ${(conditional {
              condition = "${EWW_BATTERY.total_avg} > ${toString chargeLevels.low.threshold}";
              ifTrue = "'${chargeLevels.normal.color}'";
              ifFalse = "${(conditional {
                condition = "${EWW_BATTERY.total_avg} > ${toString chargeLevels.critical.threshold}";
                ifTrue = "'${chargeLevels.low.color}'";
                ifFalse = "'${chargeLevels.critical.color}'";
              })}";
            })} }"
            "font-size: 16px"
          ]}"
        )

        ;; Charge
        (box
          :style "${style [
            "padding-left: 4px"
            "padding-right: 4px"
          ]}"
          (scale
            :value "${percentage}"
            :orientation "horizontal"
            :min 0 :max 100
            :class "${widgetName}-scale ${(conditional {
              condition = "${EWW_BATTERY.total_avg} > ${toString chargeLevels.low.threshold}";
              ifTrue = "normal";
              ifFalse = "${(conditional {
                condition = "${EWW_BATTERY.total_avg} > ${toString chargeLevels.critical.threshold}";
                ifTrue = "low";
                ifFalse = "critical";
              })}";
            })}"
          )
        )
        
        (box
          :space-evenly false
          :spacing 4
          :style "${style [
            "background: #${colors.surface1}"
            "margin-top: 2px"
            "margin-bottom: 2px"
            "border-radius: ${toString (wm-config.rounding * 512)}px"
            "padding-left: 8px"
            "padding-right: 8px"
          ]}"

          ;; Charge / Discharge icon
          (label
            :text "''${${(conditional {
              condition = "${EWW_BATTERY.status} == 'Charging'";
              ifTrue = "'${icons.charging}'";
              ifFalse = "'${icons.discharging}'";
            })}}"
            :style "${style [
              "color: #\${${(conditional {
                condition = "${EWW_BATTERY.status} == 'Charging'";
                ifTrue = "'${colors.teal}'";
                ifFalse = "'${colors.yellow}'";
              })}}"
            ]}"
          )

          ;; Powerdrain
          (label
            :text "''${ ${variables.powerdrain} }w | ${percentage}%"
            :style "${style [
              "color: #${colors.text}"
            ]}"
          )
        )
      )
    )
  '';

  xdg.configFile."eww/${moduleName}.scss".text = /* scss */ ''
    .${widgetName}-scale {
      trough {
        min-width: 96px;
        min-height: 6px;
        background: #${colors.surface2};
        border-radius: ${toString (wm-config.rounding * 512)}px;
        highlight {
          border-radius: ${toString (wm-config.rounding * 512)}px;
          background: #${chargeLevels.normal.color};
        }
      }
    }
  '';
} 
