{
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
  inherit (config) wm-config;
  moduleName = "statusbar/keyboard";
in {
  xdg.configFile."eww/${moduleName}.yuck".text = let
    ruLayoutShorthand = "\keyboard-layout == \"Russian\" ? \"RU\" : \"\"";
    enLayoutShorthand = "\${keyboard-layout == \"English (US)\" ? \"US\" : ${ruLayoutShorthand}}";
    layoutShorthand = enLayoutShorthand;

    keyboardIcon = "󰌌";
  in ''
    (deflisten keyboard-layout
      "hyprquery -sq keyboard-layout"
    )

    (defwidget keyboard-layout []
      (box
        :class "keyboard widget"
        :orientation "vertical"
        :space-evenly false
        (label
          :class "icon"
          :text "${keyboardIcon}"
        )
        (label
          :class "layout"
          :text "${layoutShorthand}"
        )
      )
    )
  '';

  xdg.configFile."eww/${moduleName}.scss".text = ''
    .keyboard {
      &.widget {
        padding: 4px;
        background-color: #${colors.base02};
        margin-top: 4px;
        margin-bottom: 4px;
        border-radius: ${toString wm-config.rounding}px;
      }

      .icon {
        // font-size: 16;
        color: #${colors.base07};
      }
    }
  '';
}
