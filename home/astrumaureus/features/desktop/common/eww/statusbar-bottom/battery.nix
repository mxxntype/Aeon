{ config, inputs, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors style wm-config;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.battery) widgetName moduleName variables;

  icons = {
    chargeLevel = "[${lib.concatStringsSep ", " [
      "\\\"󰁺\\\""
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

  percentage = "\${ round(EWW_BATTERY.total_avg, 0) }";
in {
  xdg.configFile."eww/${moduleName}.yuck".text = ''
    (defvar ${variables.chargeLevelIcons} "${icons.chargeLevel}")
    (defpoll ${variables.powerdrain}
      :interval "2s"
      "powerdrain")
    
    (defwidget ${widgetName} []
      (box
        :halign "end"
        :space-evenly false
        :style "${style [
          "background: #${colors.base02}"
          "border-radius: 512px"
          "margin-top: 4px"
          "padding-left: 8px"
          "padding-right: 2px"
          "margin-left: 4px"
          "margin-right: 4px"
        ]}"

        ;; Icon
        (label
          :text "''${${variables.chargeLevelIcons}[round( EWW_BATTERY.total_avg / 10, 0) - 1]}"
          :style "${style [
            "color: #${colors.base0A}"
            "font-size: 16px"
          ]}"
        )

        ;; Charge
        (progress
          :value "${percentage}"
          :orientation "horizontal"
          :style "${style [
            "color: #${colors.base06}"
          ]}"
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
            :text "''${ EWW_BATTERY.BAT0.status == 'Charging' ? '${icons.charging}' : '${icons.discharging}' }"
            :style "${style [
              "color: #\${ EWW_BATTERY.BAT0.status == 'Charging' ? '${colors.base0B}' : '${colors.base09}' }"
              # "font-size: 16px"
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
}
