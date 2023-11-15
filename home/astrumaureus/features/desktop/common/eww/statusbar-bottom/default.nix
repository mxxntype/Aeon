# INFO: Statusbar widget

{ inputs, config, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors style wm-config largestMonitor;
  inherit (shared.widgets.statusbars.bottom) widgetName moduleName subModules;
  dockStyle = (style [
    "background: #${colors.base}"
    "border-top-left-radius: ${toString wm-config.rounding}px"
    "border-top-right-radius: ${toString wm-config.rounding}px"
    "padding-left: 4px"
    "padding-right: 4px"
    "border: 1px solid #${colors.surface0}"
    "border-bottom: none"
    # "color: #${colors.surface0}"
  ]);
in {
  imports = [
    ./workspaces.nix
    ./music.nix
    ./battery.nix
    ./clock.nix
    ./keyboard.nix
  ];

  xdg.configFile."eww/${moduleName}.yuck".text = lib.concatLines [
    ''
      ;; Include all sub-widget definitions      
      ${lib.concatLines (lib.forEach (builtins.attrValues subModules) (sm: ''
        (include "./${sm.moduleName}.yuck")
      ''))}
    ''

    '';; Widgets
      (defwidget ${widgetName} []
        (box
          :spacing ${toString (wm-config.gaps.inner * 2)}

          ;; Left dock
          (box
            :style "${dockStyle}"
            (${subModules.music.widgetName} :position "center")
          )

          ;; Middle dock
          (centerbox
            :space-evenly false
            :style "${dockStyle}"
            (${subModules.clock.widgetName} :position "start")
            (${subModules.workspaces.widgetName} :position "center")
            (${subModules.keyboard.widgetName} :position "end")
          )

          ;; Right dock
          (box
            :style "${dockStyle}"
            (${subModules.battery.widgetName} :position "end")
          )
        )
      )
    ''
  
    '';; Windows
      (defwindow ${widgetName}
        :monitor 0
        :geometry (geometry
          :anchor "bottom center"
          :width "${toString (largestMonitor.width / largestMonitor.scale - (2 * wm-config.gaps.outer))}"
        )
        :stacking "fg"
        :exclusive true
        :focusable false
        (${widgetName})
      )
    ''
  ];
}
