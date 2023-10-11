# INFO: Music widget

{ inputs, config, lib, pkgs, ... }: let
  shared = import ../shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors style wm-config;
  inherit (shared.widgets.statusbars.bottom) subModules;
  inherit (subModules.music) widgetName moduleName;

  mpc-listener = pkgs.writeShellScriptBin "mpc-listener" ''
    while true; do
      mpc current -f '%title%' | head --lines 1
      mpc idle player > /dev/null
    done
  '';
in {
  xdg.configFile."eww/${moduleName}.yuck".text = ''
    (deflisten mpc-title "${mpc-listener}/bin/mpc-listener")
    (defwidget ${widgetName} []
      ${(shared.mixin-widgets.containers.with-icon {
        fg = colors.base0E;
        bg = colors.base02;
        text = "\${mpc-title}";
        icon = "󰝚";
      })}
    )
  '';

  home.packages = [ mpc-listener ];
}
