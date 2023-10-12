# INFO: Functions & variables for use in Eww.

{ inputs, config, lib, pkgs, ... }: rec {
  inherit (config.colorscheme) colors;
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

  # Helpful aliases
  style = lib.concatStringsSep ";";
  bashBatch = lib.concatStringsSep "; ";
  bashSequence = lib.concatStringsSep " && ";

  # Mixins
  container = let
    margin.vertical = 4;
  in { background }: (style [
    "border-radius: 512px"
    "background: #${background}"
    "margin-top: ${toString margin.vertical}px"
    # "margin-bottom: ${toString margin.vertical}px"
  ]);

  mixin-widgets = {
    containers = {
      with-icon = { fg, bg, icon, text }: ''
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
              "border-top-left-radius: 512px"
              "border-bottom-left-radius: 512px"
            ]}")
          (label
            :text "${toString text}"
            :style "${style [
              "background: #${bg}"
              "margin-top: 4px"
              "color: #${colors.base05}"
              "padding-left: 8px"
              "padding-right: 8px"
              "border-top-right-radius: 512px"
              "border-bottom-right-radius: 512px"
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
    statusbar.name = "statusbar";
    powermenu.name = "powermenu";

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
        widgetName = "statusbar-bottom";
        moduleName = "${statusbars.bottom.widgetName}/${statusbars.bottom.widgetName}";
        subModules = {
          workspaces = rec {
            widgetName = "${statusbars.bottom.widgetName}-workspaces";
            moduleName = "${statusbars.bottom.widgetName}/${widgetName}";
            variables = builtins.listToAttrs (lib.forEach [
              "workspaces"
              "active-workspace"
            ] (var: {
              name = toString var;
              value = "${statusbars.bottom.widgetName}-${toString var}";
            }));
          };
          music = rec {
            widgetName = "${statusbars.bottom.widgetName}-music";
            moduleName = "${statusbars.bottom.widgetName}/${widgetName}";
          };
        };
      };
    };
  };
}
