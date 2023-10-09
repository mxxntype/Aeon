# INFO: Statusbar widget

{ inputs, config, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors style wm-config largestMonitor;
  inherit (shared.widgets.statusbars.bottom) widgetName moduleName subModules;
  dockStyle = (style [
    "background: #${colors.base00}"
    "border-top-left-radius: ${toString wm-config.rounding}px"
    "border-top-right-radius: ${toString wm-config.rounding}px"
    "color: #${colors.base02}" # FIXME
  ]);
in {
  imports = [
    ./workspaces.nix
  ];

  xdg.configFile."eww/${moduleName}.yuck".text = ''
    ${lib.concatStringsSep "\n" (lib.forEach (builtins.attrValues subModules) (sm: ''
      (include "./${sm.moduleName}.yuck")
    ''))}
  
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

    (defwidget ${widgetName} []
      (box
        :spacing ${toString (2 * wm-config.gaps.inner)}

        (box
          :style "${dockStyle}"
          "${widgetName}-0"
        )

        (box
          :style "${dockStyle}"
          (${subModules.workspaces.widgetName})
        )

        (box
          :style "${dockStyle}"
          "${widgetName}-2"
        )
      )
    )
  '';
}
