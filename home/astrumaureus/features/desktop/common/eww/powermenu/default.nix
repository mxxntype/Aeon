# INFO: Eww-powered, keyboard-driven powermenu for Hyprland

{
  config,
  pkgs,
  lib,
  ...
}: let
  widgetName = "powermenu";
  moduleName = "${widgetName}/${widgetName}";

  shared = import ../shared.nix { inherit config lib; };
  inherit (shared) style colors wm-config variables;

  tileHeight = 150;
  tileWidth = tileHeight;
  tileSpacing = 8;

  resetCommand = lib.concatStringsSep " && " [
    "hyprctl dispatch submap reset"
    "eww close ${widgetName}"
    "eww-powermenu-ctl --set-focus 0 1"
  ];

  # NOTE: Now in ../shared.nix
  # variables.powermenuActiveRow = "powermenu-active-row";
  # variables.powermenuActiveCol = "powermenu-active-col";

  entry = {
    position ? {
      row = 0;
      col = 0;
    },
    icon ? "",
    text ? "Entry",
    command ? "echo",
    color ? "#${colors.base05}",
  }: {
    command = command;
    syntax = ''
      (eventbox

        :onhover "${lib.concatStringsSep " " [
          "eww-powermenu-ctl"
          "--set-focus"
          "${toString position.row} ${toString position.col}"

          # "&&"

          # "hyprctl notify"
          # "-1 1000"                    # Timeout
          # "'rgb(${colors.base0A})'"    # Color
          # "'${widgetName}: gained hover [${toString position.row}:${toString position.col}]'"

          # "&&"

          # "hyprctl notify"
          # "-1 3000"                    # Timeout
          # "'rgb(${colors.base0E})'"    # Color
          # "$(eww get ${variables.powermenuActiveRow}):$(eww get ${variables.powermenuActiveCol})"
        ]}"

        :onhoverlost "${lib.concatStringsSep " " [
          "eww-powermenu-ctl"
          "--set-focus"
          "-1 -1"

          # "&&"

          # "hyprctl notify"
          # "-1 1000"                    # Timeout
          # "'rgb(${colors.base06})'"    # Color
          # "'${widgetName}: lost hover [${toString position.row}:${toString position.col}]'"
        ]}" 

        (box
          :orientation "vertical"
          :space-evenly false
          :width ${toString tileWidth}
          :height ${toString tileHeight}
          :style "${style [
            "background-color: #${colors.base02}"
            "border-radius: ${toString wm-config.rounding}px"
          ]}"

          (button
            :vexpand true
            :onclick "${toString command} & ${resetCommand}"
            :class "${widgetName}-entry ''${${variables.powermenuActiveRow} == "${toString position.row}" ? ${variables.powermenuActiveCol} == "${toString position.col}" ? "active" : "" : ""}"
            :style "${style [
              "color: #${color}"
              "font-size: ${toString (tileHeight / 4)}px"
              "border-radius: ${toString wm-config.rounding}px"
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
  };

  entries = [
    # Row 0
    [
      (entry {
        position = {
          row = 0;
          col = 0;
        };
        icon = "󰌾";
        text = "Lockscreen";
        command = "hyprlock.sh";
        color = colors.base0F;
      })

      (entry {
        position = {
          row = 0;
          col = 1;
        };
        icon = "󰤄";
        text = "Suspend";
        command = "hyprsuspend.sh";
        color = colors.base0E;
      })

      (entry {
        position = {
          row = 0;
          col = 2;
        };
        icon = "󰗼";
        text = "Exit Hyprland";
        command = "hyprexit.sh";
        color = colors.base0D;
      })
    ]

    # Row 2
    [
      (entry {
        position = {
          row = 1;
          col = 0;
        };
        icon = "󰐥";
        text = "Shutdown";
        command = "systemctl poweroff";
        color = colors.base06;
      })

      (entry {
        position = {
          row = 1;
          col = 1;
        };
        icon = "󰜉";
        text = "Reboot";
        command = "systemctl reboot";
        color = colors.base07;
      })
    ]
  ];

  eww-powermenu-ctl = pkgs.writeShellScriptBin "eww-powermenu-ctl" ''
    if [[ "$1" == "--set-focus" ]]; then
      eww update ${variables.powermenuActiveRow}=$2
      eww update ${variables.powermenuActiveCol}=$3
    elif [[ "$1" == "--update-focus" ]]; then
      eww update ${variables.powermenuActiveRow}=$(( $(eww get ${variables.powermenuActiveRow}) + $2))
      eww update ${variables.powermenuActiveCol}=$(( $(eww get ${variables.powermenuActiveCol}) + $3))
    elif [[ "$1" == "--trigger" ]]; then
      eval $(jq ".[$2][$3]" < ~/.config/eww/${moduleName}.json | tr -d '"')
    fi
  '';
in {
  xdg.configFile."eww/${moduleName}.yuck".text = ''
    (defvar ${variables.powermenuActiveRow} 0)
    (defvar ${variables.powermenuActiveCol} 1)

    (defwidget ${widgetName} []
        (box
            :orientation "vertical"
            :spacing "${toString tileSpacing}"
            :style "${style [
                "padding: 8px"
                "background-color: #${colors.base00}"
                "border-radius: ${toString wm-config.rounding}px"
            ]}"

            ${lib.concatLines (lib.forEach entries (row: ''
                    (box
                        :spacing ${toString tileSpacing}
                        :orientation "horizontal"
                        ${lib.concatLines (lib.forEach row (entry: entry.syntax))}
                    )
                ''))
            }
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

  xdg.configFile."eww/${moduleName}.scss".text = ''
    .${widgetName}-entry {
      &.active {
        background-color: #${colors.base03};
      }
    }
  '';

  xdg.configFile."eww/${moduleName}.json".text = builtins.toJSON (
    lib.forEach entries (row: (
      lib.forEach row (entry: entry.command)
    ))
  );

  wayland.windowManager.hyprland.configParts = [
    ''
      # Show the ${widgetName} & enter its submap
      bind = SUPER SHIFT, E, exec, eww open ${widgetName}
      bind = SUPER SHIFT, E, submap, eww-${widgetName}

      submap = eww-${widgetName}

        # Shift focus between entries
        bind = , h, exec, eww-powermenu-ctl --update-focus 0 -1
        bind = , j, exec, eww-powermenu-ctl --update-focus 1 0
        bind = , k, exec, eww-powermenu-ctl --update-focus -1 0
        bind = , l, exec, eww-powermenu-ctl --update-focus 0 1

        # Execute the command assigned to the ${widgetName} entry
        bind = , RETURN, exec, ${lib.concatStringsSep " " [
          "eww-powermenu-ctl --trigger $(eww get ${variables.powermenuActiveRow}) $(eww get ${variables.powermenuActiveCol}) &"
          "${resetCommand}"
        ]}

        # Close the ${widgetName} & exit the submap without doing anything
        bind = SUPER SHIFT, E, exec, ${resetCommand}
        bind = , escape, exec, ${resetCommand}

      submap = reset
    ''
  ];

  home.packages = [
    eww-powermenu-ctl
  ];
}
