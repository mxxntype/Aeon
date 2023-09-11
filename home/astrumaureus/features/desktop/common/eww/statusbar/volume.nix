{
  config,
  lib,
  ...
}: let
  inherit (config.colorscheme) colors;
  inherit (config) wm-config;
  widgetName = "volume";
  moduleName = "statusbar/${widgetName}";
  style = lib.concatStringsSep ";";
in {
  xdg.configFile."eww/${moduleName}.yuck".text = ''
    (defpoll pipewire-volume
      :interval "2s"
      "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}'"
    )
    (defpoll pipewire-mute
      :interval "2s"
      "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}'"
    )

    (defwidget volume []
      (box
        :orientation "vertical"
        :style "${style [
          "background-color: #${colors.base02}"
          "padding: 4px"
          "border-radius: ${toString wm-config.rounding}px"
          "color: #${colors.base05}"
        ]}"
        (label
          :style "${style [
            "color: #\${pipewire-mute == '[MUTED]' ? '${colors.base06}' : '${colors.base0A}'}"
          ]}"
          :text "󰋋"
        )
        (label
          :text "''${pipewire-volume * 100}%"
        )
      )
    )
  '';
}
