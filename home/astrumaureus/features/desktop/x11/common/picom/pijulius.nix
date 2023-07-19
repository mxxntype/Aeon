# INFO: Picom, X11 compositor (Pijulius' fork)

{
  pkgs,
  ...
}: {
  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";

    fade = true;
    fadeDelta = 5;
    shadow = false;

    activeOpacity = 1.0;
    inactiveOpacity = 1.0;

    settings = {
      animations = true;

      animation-stiffness = 300;
      animation-window-mass = 0.7;
      animation-dampening = 25;
      animation-clamping = true;

      animation-for-open-window = "zoom";
      # animation-for-unmap-window = "slide-out";
      animation-for-workspace-switch-in = "zoom";
      # animation-for-workspace-switch-out = "slide-out";
      animation-for-transient-window = "slide-down";
      animation-for-menu-window = "slide-down";

      blur-method = "dual_kawase";

      # TODO: Inherit from host configuration
      frame-rate = 60;

      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      detect-client-leader = true;
      glx-no-stencil = true;
      use-damage = true;
      transparent-clipping = false;
      underir-if-possible = false;
      log-level = "warn"; 
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

