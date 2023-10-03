# Functions & variables for use in Eww.

{ config, lib, ... }: rec {
  inherit (config.colorscheme) colors;
  inherit (config) wm-config;
  style = lib.concatStringsSep ";";
  bashBatch = lib.concatStringsSep "; ";
  bashSequence = lib.concatStringsSep " && ";

  variables = {
    powermenuActiveRow = "powermenu-active-row";
    powermenuActiveCol = "powermenu-active-col";
    revealerShow = "revealer-show";
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
  };
}
