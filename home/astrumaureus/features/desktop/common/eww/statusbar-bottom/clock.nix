# INFO: Time widget

{ inputs, config, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors style wm-config;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.clock) widgetName moduleName variables;
in {
  xdg.configFile."eww/${moduleName}.yuck".text = /* yuck */ ''
    (defpoll ${variables.time}
      :interval "10s"
      'date +"%H:%M"')

    (defwidget ${widgetName} [position]
      (box
        :halign position
        ${(shared.mixin-widgets.containers.with-icon {
          fg = colors.blue;
          bg = colors.surface0;
          text = "\${${variables.time}}";
          icon = "";
        })}
      )
    )
  '';
}
