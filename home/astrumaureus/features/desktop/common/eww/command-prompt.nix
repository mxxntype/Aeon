# INFO: `Command prompt` widget for executing something in $PATH

{ inputs, config, lib, pkgs, ... }: let
  shared = import ./shared.nix { inherit inputs config lib pkgs; };
  inherit (shared) colors style wm-config;
  inherit (shared.widgets) commandPrompt;
in {
  xdg.configFile."eww/${commandPrompt.name}.yuck".text = /* yuck */ ''
    (defvar ${commandPrompt.variables.commands} "")

    (defwidget ${commandPrompt.name} []
      (box
        :orientation "vertical"
        :space-evenly false
        :style "${style [
          "padding: 8px"
          "background: #${colors.base}"
          "border-radius: ${toString wm-config.rounding}px"
        ]}"
        (input
          :value "Binary name..."
          :onchange "eww update ${commandPrompt.variables.commands}=$(reddot {} -m 10)"
          :onaccept "${shared.bashSequence [
            "hyprctl dispatch exec \${jq(${commandPrompt.variables.commands}, '.[0]')}"
            commandPrompt.resetCommand
          ]}"
        )
        (box
          :orientation "vertical"
          :spacing 2
          (for command in ${commandPrompt.variables.commands}
            (label
              :style "${style [
                "background: #${colors.surface0}"
                "border-radius: ${toString wm-config.rounding}px"
                "color: #${colors.blue}"
              ]}"
              :text command
            )
          )
        )
      )
    )
    
    (defwindow ${commandPrompt.name}
      :monitor 0
      :geometry (geometry
        :anchor "center"
      )
      :stacking "overlay"
      :exclusive false
      :focusable true
      (${commandPrompt.name})
    )
  '';

  wayland.windowManager.hyprland.configParts = [
    /* toml */ ''
      # Show the ${commandPrompt.name} & enter its submap
      bind = ${commandPrompt.openBind}, exec, eww open ${commandPrompt.name}
      bind = ${commandPrompt.openBind}, submap, eww-${commandPrompt.name}

      submap = eww-${commandPrompt.name}

        # Close the ${commandPrompt.name} & exit the submap without doing anything
        bind = ${commandPrompt.openBind}, exec, ${commandPrompt.resetCommand}
        bind = , escape, exec, ${commandPrompt.resetCommand}

      submap = reset
    ''
  ];
}
