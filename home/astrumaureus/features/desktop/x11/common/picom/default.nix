# INFO: Picom, X11 compositor

{
  pkgs,
  lib,
  ...
}: {
  services.picom = {
    enable = true;
    vSync = true;

    fade = true;
    shadow = false;

    activeOpacity = 1.0;
    inactiveOpacity = 1.0;

    settings = {
      animations = true;

      animation-stiffness = 300;
      animation-window-mass = 0.7;
      animation-dampening = 25;
      animation-clamping = false;

      animation-for-open-window = "zoom";
      animation-for-unmap-window = "zoom";
      animation-for-workspace-switch-in = "zoom";
      animation-for-workspace-switch-out = "zoom";
      animation-for-transient-window = "slide-down";
      animation-for-menu-window = "slide-down";

      # TODO: Inherit from host configuration
      frame-rate = 60;

      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-transient = true;
      detect-client-leader = true;
      unredir-if-possible = true;
    };

     # Pijulius' Picom
     package = pkgs.picom.overrideAttrs(o: {
        src = pkgs.fetchFromGitHub {
          repo = "picom";
          owner = "pijulius";
          rev = "982bb43e5d4116f1a37a0bde01c9bda0b88705b9";
          sha256 = "YiuLScDV9UfgI1MiYRtjgRkJ0VuA1TExATA2nJSJMhM=";
        };
    });
  };
}

