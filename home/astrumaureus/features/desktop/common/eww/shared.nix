# INFO: Functions & variables for use in Eww.

{ inputs, config, lib, pkgs, ... }: rec {
  inherit (config.theme) colors;
  inherit (config) wm-config;

  # My CLI utils
  hyprquery = inputs.hyprquery.defaultPackage.${pkgs.system};
  reddot = inputs.reddot.defaultPackage.${pkgs.system};

  # Monitors' resolutions
  inherit (config) monitors;
  enabledMonitors = lib.filter (m: m.enable) monitors;
  largestMonitor = builtins.foldl' (acc: monitor: let
      maxWidth = if monitor.width > acc.width then monitor.width else acc.width;
      maxHeight = if monitor.height > acc.height then monitor.height else acc.height;
      maxScale = if monitor.scale > acc.scale then monitor.scale else acc.scale;
    in {
      width = maxWidth;
      height = maxHeight;
      scale = maxScale;
    }
  ) { width = 0; height = 0; scale = 0; } enabledMonitors;

  mkVariables = {
    names,
    prefix ? "",
  }: builtins.listToAttrs (lib.forEach names (name: {
    name = toString name;
    value = "${toString prefix}-${toString name}";
  }));

  # Helpful aliases
  style = lib.concatStringsSep ";";
  bashBatch = lib.concatStringsSep "; ";
  bashSequence = lib.concatStringsSep " && ";
  conditional = { condition, ifTrue, ifFalse }: (lib.concatStringsSep " " [
    "${toString condition} ? ${toString ifTrue} : ${toString ifFalse}"
  ]);

  # Mixins
  container = let
    margin.vertical = 4;
  in { background }: (style [
    "border-radius: ${toString (wm-config.rounding * 512)}px"
    "background: #${background}"
    "margin-top: ${toString margin.vertical}px"
  ]);

  mixin-widgets = {
    containers = {
      with-icon = { fg, bg, icon, text }: /* yuck */ ''
        (box
          :halign "center"
          :space-evenly false
          (label
            :text "${toString icon}"
            :style "${style [
              "background: #${fg}"
              "margin-top: 4px"
              "color: #${bg}"
              "padding-left: 8px"
              "padding-right: 8px"
              "border-top-left-radius: ${toString (wm-config.rounding * 512)}px"
              "border-bottom-left-radius: ${toString (wm-config.rounding * 512)}px"
            ]}")
          (label
            :text "${toString text}"
            :style "${style [
              "background: #${bg}"
              "margin-top: 4px"
              "color: #${colors.text}"
              "padding-left: 8px"
              "padding-right: 8px"
              "border-top-right-radius: ${toString (wm-config.rounding * 512)}px"
              "border-bottom-right-radius: ${toString (wm-config.rounding * 512)}px"
            ]}")
        )
      '';
    };
  };

  # TODO: Move to relevant widgets
  variables = {
    powermenuActiveRow = "powermenu-active-row";
    powermenuActiveCol = "powermenu-active-col";
  };

  widgets = rec {
    powermenu = {
      name = "powermenu";
    };
    commandPrompt = {
      name = "command-prompt";
      openBind = "SUPER, D";
      variables = {
        commands = "${commandPrompt.name}-commands";
      };
      resetCommand = bashBatch [
        "hyprctl dispatch submap reset"
        "eww close ${commandPrompt.name}"
      ];
    };

    statusbars = {
      bottom = {
        widgetName = "statusbar";
        moduleName = "${statusbars.bottom.widgetName}/${statusbars.bottom.widgetName}";
        subModules = {
          workspaces = rec {
            widgetName = "${statusbars.bottom.widgetName}-workspaces";
            moduleName = "${statusbars.bottom.widgetName}/${widgetName}";
            variables = (mkVariables {
              prefix = statusbars.bottom.widgetName;
              names = [
                "workspaces"
                "active-workspace"
              ];
            });
          };

          music = rec {
            widgetName = "${statusbars.bottom.widgetName}-music";
            moduleName = "${statusbars.bottom.widgetName}/${widgetName}";
            variables = (mkVariables {
              prefix = statusbars.bottom.widgetName;
              names = [ "mpc-listener" ];
            });
          };

          clock = rec {
            widgetName = "${statusbars.bottom.widgetName}-clock";
            moduleName = "${statusbars.bottom.widgetName}/${widgetName}";
            variables = (mkVariables {
              prefix = statusbars.bottom.widgetName;
              names = [ "time" ];
            });
          };

          date = rec {
            widgetName = "${statusbars.bottom.widgetName}-date";
            moduleName = "${statusbars.bottom.widgetName}/${widgetName}";
            variables = (mkVariables {
              prefix = statusbars.bottom.widgetName;
              names = [ "date" ];
            });
          };

          keyboard = rec {
            widgetName = "${statusbars.bottom.widgetName}-keyboard";
            moduleName = "${statusbars.bottom.widgetName}/${widgetName}";
            variables = (mkVariables {
              prefix = statusbars.bottom.widgetName;
              names = [ "layout" ];
            });
          };

          battery = rec {
            widgetName = "${statusbars.bottom.widgetName}-battery";
            moduleName = "${statusbars.bottom.widgetName}/${widgetName}";
            variables = (mkVariables {
              prefix = statusbars.bottom.widgetName;
              names = [
                "chargeLevelIcons"
                "powerdrain"
              ];
            });
          };
        };
      };
    };
  };
}
