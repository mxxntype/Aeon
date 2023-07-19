# INFO: Picom, X11 compositor (Arian8j2's fork)

{
  pkgs,
  ...
}: {
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    fade = true;
    fadeDelta = 4;
    settings = {
      blur-method = "dual_kawase";

      transition = false;
      transition-offset = 200;
      transition-step = 0.02;
      transition-direction = "smart-x";
      transition-timing-function = "ease-out-expo";
    };

    # Arian8j2' Picom
    package = pkgs.picom.overrideAttrs(o: {
      src = pkgs.fetchFromGitHub {
        repo = "picom";
        owner = "Arian8j2";
        rev = "0de63f09d0229859bee90376344c87aa07ba14dd";
        sha256 = "cETsjofpWXF+lICZvLGuwVrkAScXgmIsLQAG4lFvw54=";
      };
      buildInputs = with pkgs; [
        xorg.xcbutil
        dbus
        libconfig
        libdrm
        libev
        libGL
        xorg.libX11
        xorg.libxcb
        libxdg_basedir
        xorg.libXext
        xorg.libXinerama
        libxml2
        libxslt
        pcre
        pcre2
        pixman
        xorg.xcbutilimage
        xorg.xcbutilrenderutil
        xorg.xorgproto
      ];
    });
  };
}
