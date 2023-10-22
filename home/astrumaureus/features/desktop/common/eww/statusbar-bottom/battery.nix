{ config, inputs, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };

  inherit (shared) colors style conditional;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.battery) widgetName moduleName variables;

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
      color = colors.base0A;
    };
    low = {
      threshold = 30;
      color = colors.base08;
    };
    critical = {
      threshold = 15;
      color = colors.base06;
    };
  };

  percentage = "\${ round(${EWW_BATTERY.total_avg}, 0) }";
in {
  xdg.configFile."eww/${moduleName}.yuck".text = ''
    (defvar ${variables.chargeLevelIcons} "${icons.chargeLevel}")
    (defpoll ${variables.powerdrain}
      :interval "2s"
      "powerdrain")
    
    (defwidget ${widgetName} [position]
      (box
        :halign position
        :space-evenly false
        :style "${style [
          "background: #${colors.base02}"
          "border-radius: 512px"
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
            "background: #${colors.base03}"
            "margin-top: 2px"
            "margin-bottom: 2px"
            "border-radius: 512px"
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
                ifTrue = "'${colors.base0B}'";
                ifFalse = "'${colors.base09}'";
              })}}"
            ]}"
          )

          ;; Powerdrain
          (label
            :text "''${ ${variables.powerdrain} }w"
            :style "${style [
              "color: #${colors.base05}"
            ]}"
          )
        )
      )
    )
  '';

  xdg.configFile."eww/${moduleName}.scss".text = ''
    .${widgetName}-scale {
      trough {
        min-width: 96px;
        min-height: 6px;
        background: #${colors.base04};
        border-radius: 512px;
        highlight {
          border-radius: 512px;
          background: #${chargeLevels.normal.color};
        }
      }
    }
  '';
} 