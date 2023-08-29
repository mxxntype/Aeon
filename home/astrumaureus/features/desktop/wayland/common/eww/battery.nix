{
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
  batteryPercentage = "\${EWW_BATTERY.BAT0.capacity}";
  powerDrain = "\${powerdrain}";
in {
  xdg.configFile."eww/statusbar/battery.yuck".text = ''
    (defpoll powerdrain
      :interval "2s"
      "powerdrain"
    )
    (defwidget battery []
      (box
        :orientation "vertical"
        (label
          :text "${batteryPercentage}%"
        )
        (label
          :text "${powerDrain}W"
        )
      )
    )
  '';

  xdg.configFile."eww/statusbar/battery.scss".text = ''
  '';
}
