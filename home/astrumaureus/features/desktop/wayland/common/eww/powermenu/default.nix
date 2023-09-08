# INFO: Eww-powered, keyboard-driven (not yet though) powermenu for Hyprland

{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config) wm-config;
  inherit (config.colorscheme) colors;

  widgetName = "powermenu";
  moduleName = "${widgetName}/${widgetName}";
  tileHeight = 150;
  tileWidth = tileHeight;
  tileSpacing = 8;

  resetCommand = lib.concatStringsSep " && " [
    "hyprctl dispatch submap reset"
    "eww close ${widgetName}"
    "eww-powermenu-ctl --set-focus -1 -1"
  ];

  powermenuActiveRow = "powermenu-active-row";
  powermenuActiveCol = "powermenu-active-col";

  style = lib.concatStringsSep ";";
  entry = {
    position ? {
      row = 0;
      col = 0;
    },
    icon ? "",
    text ? "Entry",
    command ? "echo",
    color ? "#${colors.base05}",
  }: let
    activeEntryPredicate = "\${${powermenuActiveRow} == ${toString position.row} ? 'active' : ''}";
  in ''
      (eventbox
        :onhover "eww-powermenu-ctl --set-focus ${toString position.row} ${toString position.col}"
        :onhoverlost "eww-powermenu-ctl --set-focus -1 -1"
        (box
          :orientation "vertical"
          :space-evenly false
          :class "${widgetName}-entry ${activeEntryPredicate}"
          :width ${toString tileWidth}
          :height ${toString tileHeight}
          :style "${style [
            "background-color: #${colors.base02};"
            "border-radius: ${toString wm-config.rounding};"
          ]}"
          (button
            :vexpand true
            :onclick "${toString command} & ${resetCommand}"
            :cursor "pointer"
            :style "${style [
              "color: #${color}"
              "font-size: ${toString (tileHeight / 4)}"
              "border-radius: ${toString wm-config.rounding};"
              "margin: 4px"
            ]}"
            "${toString icon}"
          )
          (label
            :text "${toString text}"
            :style "${style [
              "padding-bottom: 4px"
              "color: #${colors.base05}"
            ]}"
          )
        )
      )
    '';

  eww-powermenu-ctl = pkgs.writeShellScriptBin "eww-powermenu-ctl" ''
    if [[ "$2" == "--set-focus" ]]; then
      eww update ${powermenuActiveRow}=$3
      eww update ${powermenuActiveCol}=$4
    fi
  '';
in {
  xdg.configFile."eww/${moduleName}.yuck".text = ''
    (defvar ${powermenuActiveRow} 0)
    (defvar ${powermenuActiveCol} 0)

    (defwidget ${widgetName} []
      (box
        :orientation "vertical"
        :style "${style [
          "padding: 8px"
          "background-color: #${colors.base00}"
          "border-radius: ${toString wm-config.rounding}"
        ]}"
        :spacing "${toString tileSpacing}"
        (box
          :orientation "horizontal"
          :spacing "${toString tileSpacing}"
          ${entry {
              position = {
                row = 0;
                col = 0;
              };
              icon = "󰌾";
              text = "Lockscreen";
              command = "hyprlock.sh";
              color = colors.base0A;
            }
          }
          ${entry {
              position = {
                row = 0;
                col = 1;
              };
              icon = "󰤄";
              text = "Suspend";
              command = "hyprsuspend.sh";
              color = colors.base08;
            }
          }
          ${entry {
              position = {
                row = 0;
                col = 2;
              };
              icon = "󰗼";
              text = "Exit Hyprland";
              command = "hyprexit.sh";
              color = colors.base0D;
            }
          }
        )
        (box
          :orientation "horizontal"
          :spacing "${toString tileSpacing}"
          ${entry {
              position = {
                row = 1;
                col = 0;
              };
              icon = "󰐥";
              text = "Shutdown";
              command = "systemctl poweroff";
              color = colors.base06;
            }
          }
          ${entry {
              position = {
                row = 1;
                col = 1;
              };
              icon = "󰜉";
              text = "Reboot";
              command = "systemctl reboot";
              color = colors.base07;
            }
          }
        )
      )
    )

    (defwindow ${widgetName}
      :monitor 0
      :geometry (geometry
        :anchor "center"
      )
      :stacking "fg"
      :exclusive false
      :focusable false
      (powermenu)
    )
  '';

  # TODO: Button:hover
  xdg.configFile."eww/${moduleName}.scss".text = ''
    .${widgetName}-entry {
      &.active {
        background-color: #${colors.base03};
      }
    }
  '';

  wayland.windowManager.hyprland.configParts = [
    ''
      bind = SUPER SHIFT, E, exec, eww open ${widgetName}
      bind = SUPER SHIFT, E, submap, eww-${widgetName}

      submap = eww-${widgetName}

      bind = SUPER SHIFT, E, exec, eww close ${widgetName}
      bind = SUPER SHIFT, E, submap, reset

      bind = , escape, exec, eww close ${widgetName}
      bind = , escape, submap, reset

      submap = reset
    ''
  ];

  home.packages = [
    eww-powermenu-ctl
  ];
}
