# INFO: Elkowar's wacky widgets

{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.colorscheme) colors;
  inherit (config) wm-config;
  inherit (config) monitors;
  enabledMonitors = lib.filter (m: m.enable) monitors;
  maxDimensions = builtins.foldl' (acc: monitor: let
      maxWidth = if monitor.width > acc.width then monitor.width else acc.width;
      maxHeight = if monitor.height > acc.height then monitor.height else acc.height;
    in {
      width = maxWidth;
      height = maxHeight;
    }
  ) { width = 0; height = 0; } enabledMonitors;
in {
  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile."eww/eww.yuck".text = let
    workspaceID = "\${ws.id}";
    occupiedWorkspacePredicate = "\ws.windows > 0 ? \"occupied\" : \"\"";
    activeWorkspacePredicate = "\${ws.id == active-workspace ? \"active\" : ${occupiedWorkspacePredicate}}";
  in ''
    (deflisten active-workspace "~/.cargo/bin/hyprquery -sq active-workspace")
    (deflisten active-window "~/.cargo/bin/hyprquery -sq active-window")
    (deflisten workspaces "~/.cargo/bin/hyprquery -sq workspaces")

    (defwindow statusbar
      :monitor 0
      :geometry (geometry
        :anchor "left center"
        :height "${toString (maxDimensions.height - (2 * wm-config.gaps.outer))}"
      )
      :stacking "fg"
      :focusable false
      :exclusive true
      (statusbar)
    )

    (defwidget statusbar []
      (box
        :class "statusbar top outer-border"
        (centerbox
          :orientation "v"
          :class "statusbar top container"
          (box
            :halign "start"
            ""
          )
          (box
            :halign "center"
            (workspaces)
          )
          (box
            :halign "end"
            ""
          )
        )
      )
    )

    (defwidget workspaces []
      (box
        :class "workspaces top container"
        :orientation "v"
        (label
          :class "workspaces active-numerical"
          :text active-workspace
        )
        (for ws in workspaces
          (box
            :class "workspaces entry ${activeWorkspacePredicate}"
            "${workspaceID}"
          )
        )
      )
    )
  '';

  xdg.configFile."eww/eww.scss".text = ''
    .statusbar {
      &.top {
        background: #${colors.base01};
        color: #${colors.base05};

        &.outer-border {
          border-right: 4px solid #${colors.base01};
          border-top: 4px solid #${colors.base01};
          border-bottom: 4px solid #${colors.base01};
        }

        &.container {
          border-right: 2px solid #${colors.base02};
          border-top: 2px solid #${colors.base02};
          border-bottom: 2px solid #${colors.base02};
          padding-right: 4px;
          padding-left: 4px;
        }
      }
    }

    .workspaces {
      &.active-numerical { color: #${colors.base02} }
      &.entry {
        &.empty { color: #${colors.base03}; }
        &.occupied { color: #${colors.base05}; }
        &.active { color: #${colors.base0E}; }
      }
    }
  '';
}
