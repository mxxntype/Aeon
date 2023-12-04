# INFO: Statusbar widget

{ inputs, config, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors style wm-config;
  inherit (shared.widgets.statusbars.bottom) widgetName moduleName subModules;
  toplevelStyle = style [
    "background: #${colors.base}"
    "border-top: ${toString wm-config.border.thickness}px solid #${colors.surface0}"
    "padding-right: 2px"
    "padding-left: 2px"
  ];
in {
  imports = [
    ./workspaces.nix
    ./music.nix
    ./battery.nix
    ./clock.nix
    ./date.nix
    ./keyboard.nix
  ];

  xdg.configFile."eww/${moduleName}.yuck".text = /* yuck */ ''
    ;; Include all sub-widget definitions
    ${lib.concatLines (lib.forEach (builtins.attrValues subModules) (sm: /* yuck */ ''
      (include "./${sm.moduleName}.yuck")
    ''))}

    ;; Widgets
    (defwidget ${widgetName} []
      (centerbox
        :style "${toplevelStyle}"
        :space-evenly true
        :spacing ${toString (wm-config.gaps.inner * 2)}

        ;; Left dock
        (box
          :halign "start"
          :space-evenly false
          :spacing 4
          (${subModules.workspaces.widgetName} :position "start")
          (${subModules.clock.widgetName} :position "center")
          (${subModules.keyboard.widgetName} :position "end")
        )

        ;; Middle dock
        (box
          :halign "center"
          :space-evenly false
          :spacing 4
          ""
          (${subModules.music.widgetName} :position "center")
          ""
        )

        ;; Right dock
        (box
          :halign "end"
          :space-evenly false
          :spacing 4
          ""
          (${subModules.date.widgetName} :position "center")
          (${subModules.battery.widgetName} :position "end")
        )
      )
    )

    ;; Windows
    (defwindow ${widgetName}
      :monitor 0
      :geometry (geometry
        :anchor "bottom center"
        :width "100%"
      )
      :stacking "fg"
      :exclusive true
      :focusable false
      (${widgetName})
    )
  '';
}
