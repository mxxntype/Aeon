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
    ./volume.nix
  ];

  xdg.configFile."eww/statusbar/statusbar.yuck".text = ''
    (include "./statusbar/clock.yuck")
    (include "./statusbar/battery.yuck")
    (include "./statusbar/workspaces-hyprland.yuck")
    (include "./statusbar/sysinfo.yuck")
    (include "./statusbar/keyboard.yuck")
    (include "./statusbar/volume.yuck")

    (defwidget statusbar []
      (box
        :class "statusbar left outer-border"
        (centerbox
          :orientation "v"
          :class "statusbar left container"
            (box
            :halign "center"
            :valign "start"
            :orientation "vertical"
            :space-evenly false
            (clock)
            (keyboard-layout)
            (volume)
          )
          (box
            :halign "center"
            :valign "center"
            :orientation "vertical"
            :space-evenly false
            (workspaces)
          )
          (box
            :halign "center"
            :valign "end"
            :orientation "vertical"
            :space-evenly false
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
        :height "${toString ((maxDimensions.height / maxDimensions.scale - (2 * wm-config.gaps.outer)))}"
      )
      :stacking "bg"
      :focusable false
      :exclusive true
      (statusbar)
    )
  '';

  xdg.configFile."eww/statusbar/statusbar.scss".text = ''
    @use './statusbar/clock';
    @use './statusbar/workspaces-hyprland';
    @use './statusbar/battery';
    @use './statusbar/sysinfo';
    @use './statusbar/keyboard';

    .statusbar {
      &.left {
        background: #${colors.base00};
        color: #${colors.base05};
        opacity: 0.95;

        &.outer-border {
          border-top-right-radius: ${toString wm-config.rounding}px;
          border-bottom-right-radius: ${toString wm-config.rounding}px;
        }

        &.container {
          border-top-right-radius: ${toString wm-config.rounding}px;
          border-bottom-right-radius: ${toString wm-config.rounding}px;
          // border-right: 2px solid #${colors.base02};
          // border-top: 2px solid #${colors.base02};
          // border-bottom: 2px solid #${colors.base02};
          padding-right: 4px;
        }
      }
    }
  '';
}
