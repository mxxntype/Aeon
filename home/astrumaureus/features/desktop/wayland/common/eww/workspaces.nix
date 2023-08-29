{
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
  inherit (config) wm-config;
in {
  xdg.configFile."eww/statusbar/workspaces.yuck".text = let
    workspaceID = "\${ws.id}";
    occupiedWorkspacePredicate = "\ws.windows > 0 ? \"occupied\" : \"empty\"";
    activeWorkspacePredicate = "\${ws.id == active-workspace ? \"active\" : ${occupiedWorkspacePredicate}}";
  in ''
    (deflisten active-workspace "~/.cargo/bin/hyprquery -sq active-workspace")
    (deflisten active-window "~/.cargo/bin/hyprquery -sq active-window")
    (deflisten workspaces "~/.cargo/bin/hyprquery -sq workspaces")

    (defwidget workspaces []
      (box
        :class "workspaces top container"
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

  xdg.configFile."eww/statusbar/workspaces.scss".text = let
    emptyWorkspaceHeight = 4;
    occupiedWorkspaceHeight = emptyWorkspaceHeight * 2;
    activeWorkspaceHeight = emptyWorkspaceHeight * 4;
  in ''
    .workspaces {
      .active-numerical { color: #${colors.base02} }
      .entry {
        min-width: ${toString emptyWorkspaceHeight}px;
        &.empty {
          min-height: ${toString emptyWorkspaceHeight}px;
          background-color: #${colors.base02};
        }
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
