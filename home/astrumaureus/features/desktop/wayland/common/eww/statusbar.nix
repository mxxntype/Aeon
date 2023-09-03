{
  config,
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
      maxScale = if monitor.scale > acc.scale then monitor.scale else acc.scale;
    in {
      width = maxWidth;
      height = maxHeight;
      scale = maxScale;
    }
  ) { width = 0; height = 0; scale = 0; } enabledMonitors;
in {
  imports = [
    ./workspaces.nix
    ./clock.nix
    ./battery.nix
    ./sysinfo.nix
    ./keyboard.nix
  ];

  xdg.configFile."eww/statusbar/statusbar.yuck".text = ''
    (include "./statusbar/clock.yuck")
    (include "./statusbar/battery.yuck")
    (include "./statusbar/workspaces.yuck")
    (include "./statusbar/sysinfo.yuck")
    (include "./statusbar/keyboard.yuck")

    (defwidget statusbar []
      (box
        :class "statusbar top outer-border"
        (centerbox
          :orientation "v"
          :class "statusbar top container"
            (box
            :halign "center"
            :valign "start"
            :orientation "vertical"
            :space-evenly false
            (clock)
            (keyboard-layout)
          )
          (box
            :halign "center"
            :valign "center"
            :orientation "vertical"
            (workspaces)
          )
          (box
            :halign "center"
            :valign "end"
            :orientation "vertical"
            (CPU)
            (battery)
          )
        )
      )
    )

    (defwindow statusbar
      :monitor 0
      :geometry (geometry
        :anchor "left center"
        :height "${toString ((maxDimensions.height - (2 * wm-config.gaps.outer)) / maxDimensions.scale)}"
      )
      :stacking "fg"
      :focusable false
      :exclusive true
      (statusbar)
    )
  '';

  xdg.configFile."eww/statusbar/statusbar.scss".text = ''
    @use './clock';
    @use './workspaces';
    @use './battery';
    @use './sysinfo';
    @use './keyboard';

    .statusbar {
      &.top {
        background: #${colors.base00};
        color: #${colors.base05};
        opacity: 0.95;

        &.outer-border {
          background: transparent;
          // border-right: 4px solid #${colors.base01};
          // border-top: 4px solid #${colors.base01};
          // border-bottom: 4px solid #${colors.base01};
        }

        &.container {
          border-top-right-radius: ${toString wm-config.rounding}px;
          border-bottom-right-radius: ${toString wm-config.rounding}px;
          border-right: 2px solid #${colors.base02};
          border-top: 2px solid #${colors.base02};
          border-bottom: 2px solid #${colors.base02};
          padding-right: 4px;
          padding-left: 4px;
        }
      }
    }
  '';
}
