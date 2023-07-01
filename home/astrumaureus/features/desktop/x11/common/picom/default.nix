{
  pkgs,
  ...
}: {
  services.picom = {
    enable = true;
    vSync = true;
    fade = true;
    activeOpacity = 1.0;
    inactiveOpacity = 0.85;

    package = pkgs.picom;             # Default picom
    # package = pkgs.picom-jonaburg;  # ISSUE: Crashes almost instantly
  };
}
