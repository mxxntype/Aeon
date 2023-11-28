# INFO: Wayland commons

{ config, pkgs, ... }: let
  inherit (config.theme) colors;
  inherit (config) wm-config;
in {
  home.packages = with pkgs; [
    wl-clipboard
    wlr-randr
    wlsunset
    swww
    grim
    slurp
    gtklock
  ];

  # OSD
  services.avizo = {
    enable = true;
    settings = {
      default = {
        time = 1.0;
        fade-in = 0.2;
        fade-out = 0.2;
        padding = 24;
      };
    };
  };

  # Notification daemon
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 3000;

    # Colors
    backgroundColor = "#${colors.base}FF";
    textColor = "#${colors.text}FF";
    progressColor = "#${colors.surface0}FF";
    borderColor = "#${colors.blue}FF";

    borderRadius = wm-config.rounding;
    borderSize = wm-config.border.thickness;
    font = "JetBrainsMono Nerd Font 12";
  };
}
