# INFO: Workspaces sub-widget

{ inputs, config, lib, pkgs, ...}: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) style colors hyprquery conditional;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.workspaces) widgetName moduleName variables;

  icons = {
    empty = "󰝣";
    occupied = "󰝤";
    active = "󰝤";
  };
in {
  xdg.configFile."eww/${moduleName}.yuck".text = /* yuck */ ''
    (deflisten ${variables.active-workspace} "${hyprquery}/bin/hyprquery -sq active-workspace")
    (deflisten ${variables.workspaces} "${hyprquery}/bin/hyprquery -sq workspaces")

    (defwidget ${widgetName} [position]
      (box
        :space-evenly false
        :halign position

        (box
          :style "${shared.container { background = colors.surface0; } + ";" + (style [
            "padding-left: 5px"
            "padding-right: 4px"
          ])}"
          (for ws in ${variables.workspaces}
            (button
              :onclick "hyprctl dispatch workspace ''${ws.id}"
              :class "${widgetName}-ws ''${ws.id}"
              :style "${style [
                "color: \${${(conditional {
                  condition = "ws.id == ${variables.active-workspace}";
                  ifTrue = "'#${colors.red}'";
                  ifFalse = conditional {
                    condition = "ws.windows > 0";
                    ifTrue = "'#${colors.text}'";
                    ifFalse = "'#${colors.surface2}'";
                  };
                })}}"
                # "padding-left: 2px"
                "padding-right: 6px"
                "font-size: 16px"
              ]}"
              "''${${conditional {
                condition = "ws.id == ${variables.active-workspace}";
                ifTrue = "'${icons.active}'";
                ifFalse = conditional {
                  condition = "ws.windows > 0";
                  ifTrue = "'${icons.occupied}'";
                  ifFalse = "'${icons.empty}'";
                };
              }}}"
            )
          )
        )

        (label
          :text ${variables.active-workspace}
          :style "${style [
            "color: transparent"
            "background: transparent"
          ]}"
        )

      )
    )
  '';

  xdg.configFile."eww/${moduleName}.scss".text = /* scss */ ''
    .${widgetName}-ws:hover {
      background: #${colors.surface1};
      border-radius: 512px;
    }
  '';
}
