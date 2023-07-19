# INFO: Picom, X11 compositor

{
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
    };
  };
}
