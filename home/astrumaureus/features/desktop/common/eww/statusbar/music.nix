# INFO: Music widget

{ inputs, config, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors style wm-config;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.music) widgetName moduleName variables;

  mpc-listener = pkgs.writeShellScriptBin "mpc-listener" ''
    while true; do
      mpc current -f '%artist% - %title%' | head --lines 1
      mpc idle player > /dev/null
    done
  '';
in {
  xdg.configFile."eww/${moduleName}.yuck".text = /* yuck */ ''
    (deflisten ${variables.mpc-listener} "${mpc-listener}/bin/mpc-listener")
    (defwidget ${widgetName} [position]
      (box
        :halign position
          ${(shared.mixin-widgets.containers.with-icon {
            fg = colors.mauve;
            bg = colors.surface0;
            text = "\${${variables.mpc-listener}}";
            icon = "󰝚";
          })}
      )
    )
  '';

  home.packages = [ mpc-listener ];
}
