{
  pkgs,
  ...
}: {
  services.picom = {
    enable = true;
    vSync = true;
    fade = true;
    shadow = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.9;

    settings = {
      # WARN: Very laggy
      /* blur = {
        method = "gaussian";
        size = 8;
        deviation = 8.0;
      };
      */
    };

    package = pkgs.picom;             # Default picom
    # package = pkgs.picom-jonaburg;  # ISSUE: Crashes almost instantly
  };
}
