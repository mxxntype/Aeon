{
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  xdg.configFile."eww/statusbar/clock.yuck".text = ''
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
          :class "clock label hour"
          :text time-hour
        )
        (label
          :class "clock label minute"
          :text time-minute
        )
      )
    )
  '';

  xdg.configFile."eww/statusbar/clock.scss".text = ''
    .clock {
      &.widget {
        padding-top: 4px;
        padding-bottom: 4px;
      }
      &.label {
        color: #${colors.base0D};
        font-weight: 600;
      }
    }
  '';
}
