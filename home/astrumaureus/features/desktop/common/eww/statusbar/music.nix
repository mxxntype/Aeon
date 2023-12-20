# INFO: Music widget

{ inputs, config, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.music) widgetName moduleName variables;

  # TODO: Change to a JSON-producing nushell script
  mpc-listener = pkgs.writeShellScriptBin "mpc-listener" /* bash */ ''
    while true; do
      CURRENT="$(mpc current)"
      if [[ ''${#CURRENT} -gt 75 ]]; then
        CURRENT="''${CURRENT:0:45}..."
      fi
      echo "$CURRENT"
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
            text = "\${${variables.mpc-listener}}"; # TODO: Change to .text or smth
            icon = "󰝚";
          })}
      )
    )
  '';

  home.packages = [ mpc-listener ];
}
