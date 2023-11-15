{
  config,
  lib,
  ...
}: let
  inherit (config.theme) colors;
  inherit (config) wm-config;
  widgetName = "volume";
  moduleName = "statusbar/${widgetName}";
  style = lib.concatStringsSep ";";
in {
  xdg.configFile."eww/${moduleName}.yuck".text = ''
    (defpoll pipewire-volume
      :interval "2s"
      :initial "0.0"
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
          "background-color: #${colors.surface0}"
          "padding: 4px"
          "border-radius: ${toString wm-config.rounding}px"
          "color: #${colors.text}"
        ]}"
        (label
          :style "${style [
            "color: #\${pipewire-mute == '[MUTED]' ? '${colors.red}' : '${colors.green}'}"
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
