# INFO: Keyboard layout widget

{ inputs, config, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors hyprquery;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.keyboard) widgetName moduleName variables;
in {
  xdg.configFile."eww/${moduleName}.yuck".text = ''
    (deflisten ${variables.layout}
      "${hyprquery}/bin/hyprquery -sq keyboard-layout")

    (defwidget ${widgetName} [position]
      (box
        :halign position
        ${(shared.mixin-widgets.containers.with-icon {
          fg = colors.base0C;
          bg = colors.base02;
          text = "\${${variables.layout}}";
          icon = "󰌌";
        })}
      )
    )
  '';
}
