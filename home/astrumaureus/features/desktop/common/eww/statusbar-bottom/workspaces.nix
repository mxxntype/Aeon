# INFO: Workspaces sub-widget

{ inputs, config, lib, pkgs, ...}: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) style colors hyprquery;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.workspaces) widgetName moduleName variables;

  icons = {
    empty = "";
    occupied = "";
    active = "";
  };

  predicates = {
    workspace = {
      active = "ws.id == ${variables.active-workspace}";
      occupied = "ws.windows > 0";
    };
  };
in {
  xdg.configFile."eww/${moduleName}.yuck".text = lib.concatLines [
    ''
      (deflisten ${variables.active-workspace} "${hyprquery}/bin/hyprquery -sq active-workspace")
      (deflisten ${variables.workspaces} "${hyprquery}/bin/hyprquery -sq workspaces")
    ''

    ''
      (defwidget ${widgetName} []
        (box
          :space-evenly false
          :halign "center"

          (box
            :style "${shared.container { background = colors.base02; }}"
            (for ws in ${variables.workspaces}
              (button
                :onclick "hyprctl dispatch workspace ''${ws.id}"
                :class "${widgetName}-ws ''${ws.id}"
                :style "${style [
                  "color: #\${${predicates.workspace.active} ? '${colors.base06}' : ${predicates.workspace.occupied} ? '${colors.base05}' : '${colors.base04}' }"
                  "padding-left: 2px"
                  "padding-right: 6px"
                  "font-size: 16px"
                ]}"
                "''${${predicates.workspace.active} ? '${icons.active}' : ${predicates.workspace.occupied} ? '${icons.occupied}' : '${icons.empty}' }"
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
    ''
  ];

  xdg.configFile."eww/${moduleName}.scss".text = ''
    .${widgetName}-ws:hover {
      background: #${colors.base03};
      border-radius: 512px;
    }
  '';
}
