{
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
  inherit (config) wm-config;

  widgetName = "workspaces-hyprland";
  moduleName = "statusbar/${widgetName}";
in {
  xdg.configFile."eww/${moduleName}.yuck".text = let
    workspaceID = "\${ws.id}";
    occupiedWorkspacePredicate = "\ws.windows > 0 ? \"occupied\" : \"\"";
    activeWorkspacePredicate = "\${ws.id == active-workspace ? \"active\" : ${occupiedWorkspacePredicate}}";
  in ''
    (deflisten active-workspace "hyprquery -sq active-workspace")
    (deflisten active-window "hyprquery -sq active-window")
    (deflisten workspaces
      :initial "[]"
      "hyprquery -sq workspaces"
    )

    (defwidget workspaces []
      (box
        :class "workspaces container"
        :orientation "v"
        :space-evenly false
        :spacing 4
        (label
          :class "active-numerical"
          :text active-workspace
        )
        (for ws in workspaces
          (eventbox
            :cursor "pointer"
            :onscroll "echo {} | sed -e 's/up/-1/g' -e 's/down/+1/g' | xargs hyprctl dispatch workspace"
            :halign "center"
            :valign "center"
            :vexpand true
            (button
              :onclick "hyprctl dispatch workspace ${workspaceID}"
              :class "entry ${activeWorkspacePredicate}"
            )
          )
        )
      )
    )
  '';

  xdg.configFile."eww/${moduleName}.scss".text = let
    emptyWorkspaceHeight = 12;
    occupiedWorkspaceHeight = emptyWorkspaceHeight * 2;
    activeWorkspaceHeight = emptyWorkspaceHeight * 3;
  in ''
    .workspaces {
      &.container {
        padding: 4px;
        margin-top: 4px;
        margin-left: 4px;
        background-color: #${colors.base02};
        border-radius: ${toString wm-config.rounding}px;
      }

      .active-numerical {
        color: #${colors.base0D};
      }

      .entry {
        transition-duration: 200ms;

        min-width: ${toString emptyWorkspaceHeight}px;
        min-height: ${toString emptyWorkspaceHeight}px;
        background-color: #${colors.base03};
        border-radius: ${toString wm-config.rounding}px;

        &.occupied {
          min-height: ${toString occupiedWorkspaceHeight}px;
          background-color: #${colors.base04};
        }
        &.active {
          min-height: ${toString activeWorkspaceHeight}px;
          background-color: #${colors.base0E};
        }
      }
    }
  '';
}
