# Functions & variables for use in Eww.

{ config, lib, ... }: {
  inherit (config.colorscheme) colors;
  inherit (config) wm-config;
  style = lib.concatStringsSep ";";

  variables = {
    powermenuActiveRow = "powermenu-active-row";
    powermenuActiveCol = "powermenu-active-col";
    revealerShow = "revealer-show";
  };
}
