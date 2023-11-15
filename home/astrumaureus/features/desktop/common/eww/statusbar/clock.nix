{
  config,
  ...
}: let
  inherit (config.theme) colors;
  inherit (config) wm-config;
in {
  xdg.configFile."eww/statusbar/clock.yuck".text = /* yuck */ ''
    (defpoll time-hour
      :interval "1m"
      "date +%H"
    )
    (defpoll time-minute
      :interval "10s"
      "date +%M"
    )

    (defwidget clock []
      (box
        :class "clock widget"
        :space-evenly false
        :orientation "vertical"
        :halign "center"
        (label
          :class "icon"
          :text "󰥔"
        )
        (label
          :class "hour"
          :text time-hour
        )
        (label
          :class "minute"
          :text time-minute
        )
      )
    )
  '';

  xdg.configFile."eww/statusbar/clock.scss".text = /* scss */ ''
    .clock {
      color: #${colors.text};
      font-weight: 600;

      &.widget {
        margin-top: 4px;
        padding: 4px;
        background-color: #${colors.surface0};
        border-radius: ${toString wm-config.rounding}px;
      }
    }
  '';
}
