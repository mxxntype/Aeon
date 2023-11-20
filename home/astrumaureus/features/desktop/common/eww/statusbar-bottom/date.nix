# INFO: Date widget

{ inputs, config, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors; # style wm-config;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.date) widgetName moduleName variables;
in {
  xdg.configFile."eww/${moduleName}.yuck".text = /* yuck */ ''
    (defpoll ${variables.date}
      :interval "60s"
      'date +"%A, %d %B %Y"')

    (defwidget ${widgetName} [position]
      (box
        :halign position
        ${(shared.mixin-widgets.containers.with-icon {
          fg = colors.mauve;
          bg = colors.surface0;
          text = "\${${variables.date}}";
          icon = "󰃭";
        })}
      )
    )
  '';
}
